/**
 * STM32 MCP Tools - 完整调试工具套件
 * 文件位置: ~/.claude/tools/mcp-server.js
 *
 * 功能：
 * - 编译烧录
 * - 串口实时监控（AI可读取）
 * - 寄存器读取与解读
 * - 变量监视
 * - 一键闭环调试
 */

const { Server } = require("@modelcontextprotocol/sdk/server/index.js");
const { StdioServerTransport } = require("@modelcontextprotocol/sdk/server/stdio.js");
const { CallToolRequestSchema, ListToolsRequestSchema } = require("@modelcontextprotocol/sdk/types.js");
const { spawn } = require("child_process");
const path = require("path");
const fs = require("fs");
const {
  createSession,
  detectKeilProject,
  issueFlashAuthorization,
  findRecentArtifacts,
  parseStlinkCandidates,
  recordEvent,
  setArtifact,
  sessionSummary,
  verifyFlashAuthorization
} = require("./closed-loop");

// ==================== 配置 ====================
const TOOLS_DIR = process.env.TOOLS_DIR || path.join(process.env.USERPROFILE, ".claude", "tools");
const DEFAULT_SERIAL_PORT = process.env.DEFAULT_SERIAL_PORT || "COM11";
const DEFAULT_SERIAL_BAUD = parseInt(process.env.DEFAULT_SERIAL_BAUD) || 115200;
const SERIAL_BUFFER_SIZE = 10000;

// ==================== 状态管理 ====================
class StateManager {
  constructor() {
    this.serialMonitor = null;
    this.serialBuffer = [];
    this.watches = new Map();
    this.debugSession = null;
    this.stats = {
      serialBytes: 0,
      serialLines: 0,
      errors: 0
    };
  }

  // 串口缓冲区操作
  pushSerialLine(line) {
    this.serialBuffer.push({
      timestamp: new Date().toISOString(),
      data: line
    });
    if (this.serialBuffer.length > SERIAL_BUFFER_SIZE) {
      this.serialBuffer.shift();
    }
    this.stats.serialLines++;
  }

  getSerialLines(count = 50) {
    return this.serialBuffer.slice(-count);
  }

  searchSerial(keyword) {
    return this.serialBuffer.filter(item =>
      item.data.includes(keyword)
    );
  }

  clearSerialBuffer() {
    this.serialBuffer = [];
  }

  // 变量监视操作
  addWatch(id, config) {
    this.watches.set(id, {
      ...config,
      history: [],
      lastValue: null
    });
  }

  removeWatch(id) {
    this.watches.delete(id);
  }

  updateWatchValue(id, value) {
    const watch = this.watches.get(id);
    if (watch) {
      watch.lastValue = value;
      watch.history.push({
        timestamp: Date.now(),
        value: value
      });
      // 保留最近1000个点
      if (watch.history.length > 1000) {
        watch.history.shift();
      }
    }
  }

  getWatchData(id, count = 100) {
    const watch = this.watches.get(id);
    if (!watch) return null;
    return {
      config: {
        expression: watch.expression,
        format: watch.format
      },
      lastValue: watch.lastValue,
      history: watch.history.slice(-count)
    };
  }
}

const state = new StateManager();
const sessions = new Map();

function runCommand(command, args = [], timeoutMs = 15000) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, { shell: false, stdio: ["ignore", "pipe", "pipe"] });
    let output = "";
    child.stdout.on("data", (data) => output += data.toString());
    child.stderr.on("data", (data) => output += data.toString());
    const timer = setTimeout(() => {
      child.kill();
      reject(new Error(`Command timed out: ${command}`));
    }, timeoutMs);
    child.on("error", (error) => {
      clearTimeout(timer);
      reject(error);
    });
    child.on("close", (code) => {
      clearTimeout(timer);
      if (code === 0) resolve(output);
      else reject(new Error(output || `Command failed with exit code ${code}: ${command}`));
    });
  });
}

function getStlinkCliPath() {
  return process.env.STLINK_PATH || "C:\\STMicroelectronics\\STM32Cube\\STM32CubeProgrammer\\bin\\STM32_Programmer_CLI.exe";
}

function getKeilCliPath() {
  return process.env.KEIL_PATH || "C:\\Keil_v5\\UV4\\UV4.exe";
}

function summarizeBuild(output) {
  const errors = (output.match(/\b(?:error|errors)\b/gi) || []).length;
  const warnings = (output.match(/\b(?:warning|warnings)\b/gi) || []).length;
  return { errors, warnings };
}

async function flashSessionArtifact(session, candidateId) {
  const cli = getStlinkCliPath();
  if (!fs.existsSync(cli)) {
    throw new Error(`STM32CubeProgrammer CLI was not found: ${cli}. Set STLINK_PATH before flashing.`);
  }
  const extension = path.extname(session.artifact.path).toLowerCase();
  if (extension !== ".hex" && extension !== ".bin") {
    throw new Error(`Unsupported firmware extension: ${extension}`);
  }
  const writeArgs = extension === ".bin"
    ? ["-c", `port=SWD sn=${candidateId}`, "-w", session.artifact.path, "0x08000000", "-v", "-rst"]
    : ["-c", `port=SWD sn=${candidateId}`, "-w", session.artifact.path, "-v", "-rst"];
  return runCommand(cli, writeArgs, 120000);
}

// ==================== 脚本执行器 ====================
function runScript(scriptName, args = [], timeoutMs = 60000) {
  return new Promise((resolve, reject) => {
    const scriptPath = path.join(TOOLS_DIR, scriptName);
    if (!fs.existsSync(scriptPath)) {
      reject(new Error(`脚本未找到: ${scriptPath}`));
      return;
    }

    const child = spawn("cmd.exe", ["/c", scriptPath, ...args], {
      shell: true,
      stdio: ['pipe', 'pipe', 'pipe']
    });

    let stdout = "";
    let stderr = "";

    child.stdout.on("data", data => stdout += data);
    child.stderr.on("data", data => stderr += data);

    const timer = setTimeout(() => {
      child.kill();
      reject(new Error("执行超时"));
    }, timeoutMs);

    child.on("close", code => {
      clearTimeout(timer);
      if (code === 0) {
        resolve(stdout);
      } else {
        reject(new Error(stderr || stdout));
      }
    });
  });
}

// ==================== 串口监控 ====================
function startSerialMonitor(comPort, baudRate) {
  return new Promise((resolve, reject) => {
    if (state.serialMonitor) {
      resolve("串口监控已在运行中");
      return;
    }

    const port = comPort || DEFAULT_SERIAL_PORT;
    const baud = baudRate || DEFAULT_SERIAL_BAUD;

    // PowerShell串口监控脚本
    const psScript = `
      $ErrorActionPreference = "Stop"
      try {
        $port = New-Object System.IO.Ports.SerialPort '${port}',${baud},None,8,One
        $port.ReadTimeout = 100
        $port.Open()
        Write-Host '[CONNECTED] ${port} @ ${baud}bps'

        while($true) {
          try {
            if($port.BytesAvailable -gt 0) {
              $line = $port.ReadLine()
              $ts = Get-Date -Format 'HH:mm:ss.fff'
              Write-Host "[$ts] $line"
            }
          } catch {
            # 读取超时，继续
          }
          Start-Sleep -Milliseconds 10
        }
      } catch {
        Write-Host "[ERROR] $_"
        exit 1
      }
    `;

    state.serialMonitor = spawn("powershell", ["-Command", psScript], {
      shell: true,
      stdio: ['pipe', 'pipe', 'pipe']
    });

    state.serialBuffer = [];
    let connected = false;

    state.serialMonitor.stdout.on("data", (data) => {
      const lines = data.toString().split('\n').filter(l => l.trim());
      lines.forEach(line => {
        if (line.includes('[CONNECTED]')) {
          connected = true;
        } else if (line.includes('[ERROR]')) {
          state.stats.errors++;
        } else {
          // 解析时间戳和数据
          const match = line.match(/^\[(\d{2}:\d{2}:\d{2}\.\d{3})\]\s*(.*)/);
          if (match) {
            state.pushSerialLine(match[2]);
          } else {
            state.pushSerialLine(line);
          }
        }
      });
    });

    state.serialMonitor.stderr.on("data", (data) => {
      state.stats.errors++;
    });

    state.serialMonitor.on("close", () => {
      state.serialMonitor = null;
      connected = false;
    });

    // 等待连接建立
    setTimeout(() => {
      if (state.serialMonitor) {
        resolve(`串口监控已启动: ${port} @ ${baud}bps\n使用 stm32_serial_read 读取数据`);
      } else {
        reject(new Error("串口监控启动失败，请检查串口是否被占用"));
      }
    }, 1500);
  });
}

function stopSerialMonitor() {
  return new Promise((resolve) => {
    if (state.serialMonitor) {
      state.serialMonitor.kill();
      state.serialMonitor = null;
      resolve("串口监控已停止");
    } else {
      resolve("串口监控未运行");
    }
  });
}

// ==================== 寄存器解读 ====================
const REGISTER_MAP = {
  GPIO: {
    MODER: { name: "模式寄存器", bits: { "00": "输入", "01": "输出", "10": "复用功能", "11": "模拟" } },
    OTYPER: { name: "输出类型", bits: { "0": "推挽", "1": "开漏" } },
    OSPEEDR: { name: "输出速度", bits: { "00": "低速", "01": "中速", "10": "高速", "11": "极高速" } },
    PUPDR: { name: "上下拉", bits: { "00": "无", "01": "上拉", "10": "下拉" } },
    IDR: { name: "输入数据", bits: {} },
    ODR: { name: "输出数据", bits: {} }
  },
  TIM: {
    CR1: { name: "控制寄存器1", bits: { CEN: "计数器使能", ARPE: "自动重载预装载" } },
    PSC: { name: "预分频器", bits: {} },
    ARR: { name: "自动重载值", bits: {} },
    CCR1: { name: "捕获/比较值1", bits: {} },
    CCER: { name: "捕获/比较使能", bits: {} }
  },
  USART: {
    SR: { name: "状态寄存器", bits: { TXE: "发送数据寄存器空", RXNE: "读数据寄存器非空", TC: "发送完成" } },
    BRR: { name: "波特率寄存器", bits: {} },
    CR1: { name: "控制寄存器1", bits: { UE: "USART使能", TE: "发送使能", RE: "接收使能" } }
  }
};

function explainRegister(peripheral, register, value) {
  const periType = peripheral.replace(/\d+/, '');
  const map = REGISTER_MAP[periType]?.[register];

  if (!map) {
    return `${register} = 0x${value.toString(16).padStart(4, '0')}`;
  }

  let result = `${register} = 0x${value.toString(16).padStart(4, '0')} (${map.name})`;

  // 解析位域
  if (register === 'CR1' && periType === 'TIM') {
    result += `\n  CEN (bit 0) = ${value & 1 ? '1 (计数器运行中)' : '0 (计数器停止)'}`;
    result += `\n  ARPE (bit 7) = ${(value >> 7) & 1 ? '1 (使能预装载)' : '0 (禁用预装载)'}`;
  } else if (register === 'SR' && periType === 'USART') {
    result += `\n  TXE (bit 7) = ${(value >> 7) & 1 ? '1 (发送寄存器空)' : '0 (发送中)'}`;
    result += `\n  RXNE (bit 5) = ${(value >> 5) & 1 ? '1 (有数据可读)' : '0 (无数据)'}`;
    result += `\n  TC (bit 6) = ${(value >> 6) & 1 ? '1 (发送完成)' : '0 (发送中)'}`;
  } else if (register === 'MODER' && periType === 'GPIO') {
    for (let i = 0; i < 16; i++) {
      const mode = (value >> (i * 2)) & 3;
      const modeStr = map.bits[mode.toString(2).padStart(2, '0')] || '未知';
      if (mode !== 0) { // 只显示非输入模式的引脚
        result += `\n  PA${i}: ${modeStr}`;
      }
    }
  }

  return result;
}

// ==================== 工具定义 ====================
const TOOLS = [
  {
    name: "stm32_feature_deliver",
    description: "Start an auditable STM32 feature-delivery loop from a Keil project and a natural-language feature goal.",
    inputSchema: {
      type: "object",
      properties: {
        project_path: { type: "string", description: "Keil project root directory" },
        feature: { type: "string", description: "Requested feature and expected behavior" },
        project_file: { type: "string", description: "Optional .uvprojx relative path when the directory has multiple projects" }
      },
      required: ["project_path", "feature"]
    }
  },
  {
    name: "stm32_project_detect",
    description: "Detect one Keil project and its configured target MCU. Rejects ambiguous project directories.",
    inputSchema: {
      type: "object",
      properties: {
        project_path: { type: "string", description: "Keil project root directory" },
        project_file: { type: "string", description: "Optional .uvprojx relative path" }
      },
      required: ["project_path"]
    }
  },
  {
    name: "stm32_session_status",
    description: "Return the current feature-delivery session state and evidence location.",
    inputSchema: { type: "object", properties: { session_id: { type: "string" } }, required: ["session_id"] }
  },
  {
    name: "stm32_session_build",
    description: "Build the Keil project locked to a feature-delivery session and return only firmware artifacts updated by that build.",
    inputSchema: { type: "object", properties: { session_id: { type: "string" }, rebuild: { type: "boolean", default: false } }, required: ["session_id"] }
  },
  {
    name: "stm32_artifact_select",
    description: "Select an explicit .hex or .bin generated inside the session project and record its SHA-256.",
    inputSchema: { type: "object", properties: { session_id: { type: "string" }, firmware_path: { type: "string" } }, required: ["session_id", "firmware_path"] }
  },
  {
    name: "stm32_flash_authorize",
    description: "Create a five-minute flash authorization bound to this session, selected firmware hash, and selected ST-Link candidate.",
    inputSchema: { type: "object", properties: { session_id: { type: "string" }, candidate_id: { type: "string" } }, required: ["session_id", "candidate_id"] }
  },
  {
    name: "stm32_hardware_discover",
    description: "List ST-Link candidates using STM32CubeProgrammer without flashing. Ambiguous candidates must be selected explicitly.",
    inputSchema: { type: "object", properties: { session_id: { type: "string" } }, required: ["session_id"] }
  },
  {
    name: "stm32_flash_session",
    description: "Flash only the explicitly selected session artifact after a matching authorization token is supplied.",
    inputSchema: {
      type: "object",
      properties: { session_id: { type: "string" }, candidate_id: { type: "string" }, authorization_token: { type: "string" } },
      required: ["session_id", "candidate_id", "authorization_token"]
    }
  },
  // 编译烧录
  {
    name: "stm32_build",
    description: "编译STM32项目",
    inputSchema: {
      type: "object",
      properties: {
        project_path: { type: "string", description: "项目路径（可选，默认当前目录）" },
        rebuild: { type: "boolean", description: "是否全量重新编译", default: false }
      }
    }
  },
  {
    name: "stm32_flash",
    description: "烧录固件到MCU",
    inputSchema: {
      type: "object",
      properties: {
        firmware_path: { type: "string", description: "固件文件路径（可选）" }
      }
    }
  },

  // 串口监控
  {
    name: "stm32_serial_start",
    description: "启动串口监控（数据会缓存供AI读取）",
    inputSchema: {
      type: "object",
      properties: {
        com_port: { type: "string", description: "串口号，如 COM11" },
        baud_rate: { type: "number", description: "波特率，默认115200" }
      }
    }
  },
  {
    name: "stm32_serial_stop",
    description: "停止串口监控",
    inputSchema: { type: "object", properties: {} }
  },
  {
    name: "stm32_serial_read",
    description: "读取串口缓冲区数据",
    inputSchema: {
      type: "object",
      properties: {
        lines: { type: "number", description: "读取行数，默认50" }
      }
    }
  },
  {
    name: "stm32_serial_search",
    description: "在串口数据中搜索关键字",
    inputSchema: {
      type: "object",
      properties: {
        keyword: { type: "string", description: "搜索关键字" }
      },
      required: ["keyword"]
    }
  },

  // 寄存器分析
  {
    name: "stm32_reg_read",
    description: "读取外设寄存器（支持: GPIOA-D, TIM1-4, USART1-2, SPI1, I2C1, RCC, ADC1）",
    inputSchema: {
      type: "object",
      properties: {
        peripheral: { type: "string", description: "外设名称，如 TIM3, GPIOA, USART1" }
      },
      required: ["peripheral"]
    }
  },
  {
    name: "stm32_reg_explain",
    description: "读取并解读寄存器含义（自动解析位域）",
    inputSchema: {
      type: "object",
      properties: {
        peripheral: { type: "string", description: "外设名称，如 TIM3" }
      },
      required: ["peripheral"]
    }
  },

  // 内存和变量
  {
    name: "stm32_mem_read",
    description: "读取内存区域",
    inputSchema: {
      type: "object",
      properties: {
        address: { type: "string", description: "起始地址，如 0x20000000" },
        size: { type: "number", description: "读取大小（字节）", default: 4 }
      },
      required: ["address"]
    }
  },
  {
    name: "stm32_watch_var",
    description: "读取变量值（通过map文件查找地址）",
    inputSchema: {
      type: "object",
      properties: {
        variable_name: { type: "string", description: "变量名" }
      },
      required: ["variable_name"]
    }
  },

  // 一键调试
  {
    name: "stm32_debug_cycle",
    description: "一键闭环调试：编译→烧录→启动串口监控",
    inputSchema: {
      type: "object",
      properties: {
        project_path: { type: "string", description: "项目路径" },
        com_port: { type: "string", description: "串口号" },
        baud_rate: { type: "number", description: "波特率" }
      }
    }
  },

  // 状态查询
  {
    name: "stm32_status",
    description: "查询当前调试状态（串口、监视等）",
    inputSchema: { type: "object", properties: {} }
  }
];

// ==================== 工具处理 ====================
async function handleToolCall(name, args) {
  switch (name) {
    case "stm32_project_detect": {
      const project = detectKeilProject(args.project_path, args.project_file);
      return JSON.stringify(project, null, 2);
    }

    case "stm32_feature_deliver": {
      const project = detectKeilProject(args.project_path, args.project_file);
      const session = createSession({ project, feature: args.feature });
      sessions.set(session.id, session);
      recordEvent(session, "feature_requested", { feature: args.feature });
      return JSON.stringify({
        ...sessionSummary(session),
        nextActions: [
          "Inspect and modify code to satisfy the feature request.",
          "Build the explicit Keil project.",
          "Select the exact generated .hex or .bin using stm32_artifact_select.",
          "Request flash authorization only after review and hardware validation."
        ]
      }, null, 2);
    }

    case "stm32_session_status": {
      const session = sessions.get(args.session_id);
      if (!session) throw new Error(`Unknown session: ${args.session_id}`);
      return JSON.stringify(sessionSummary(session), null, 2);
    }

    case "stm32_session_build": {
      const session = sessions.get(args.session_id);
      if (!session) throw new Error(`Unknown session: ${args.session_id}`);
      const keil = getKeilCliPath();
      if (!fs.existsSync(keil)) {
        throw new Error(`Keil UV4.exe was not found: ${keil}. Set KEIL_PATH to the installed UV4.exe.`);
      }
      const startedAt = Date.now();
      let output;
      try {
        output = await runCommand(keil, [args.rebuild ? "-r" : "-b", session.project.projectFile], 180000);
      } catch (error) {
        output = error.message;
        fs.writeFileSync(path.join(session.evidenceDir, "build.log"), output);
        const summary = summarizeBuild(output);
        recordEvent(session, "build_failed", summary);
        throw new Error(`Keil build failed: ${JSON.stringify(summary)}. Log: ${path.join(session.evidenceDir, "build.log")}`);
      }
      fs.writeFileSync(path.join(session.evidenceDir, "build.log"), output);
      const summary = summarizeBuild(output);
      const artifacts = findRecentArtifacts(session.project.root, startedAt);
      session.phase = "REVIEW_BUILD";
      recordEvent(session, "build_completed", { ...summary, artifacts });
      return JSON.stringify({ session_id: session.id, phase: session.phase, ...summary, artifacts, log: path.join(session.evidenceDir, "build.log") }, null, 2);
    }

    case "stm32_artifact_select": {
      const session = sessions.get(args.session_id);
      if (!session) throw new Error(`Unknown session: ${args.session_id}`);
      const artifact = setArtifact(session, args.firmware_path);
      session.phase = "REVIEW_BUILD";
      return JSON.stringify({ session_id: session.id, phase: session.phase, artifact }, null, 2);
    }

    case "stm32_flash_authorize": {
      const session = sessions.get(args.session_id);
      if (!session) throw new Error(`Unknown session: ${args.session_id}`);
      const authorization = issueFlashAuthorization(session, { candidateId: args.candidate_id });
      return JSON.stringify({
        session_id: session.id,
        phase: session.phase,
        candidate_id: authorization.candidateId,
        artifact_sha256: authorization.artifactSha256,
        expires_at: new Date(authorization.expiresAt).toISOString(),
        authorization_token: authorization.token
      }, null, 2);
    }

    case "stm32_hardware_discover": {
      const session = sessions.get(args.session_id);
      if (!session) throw new Error(`Unknown session: ${args.session_id}`);
      const cli = getStlinkCliPath();
      if (!fs.existsSync(cli)) {
        throw new Error(`STM32CubeProgrammer CLI was not found: ${cli}. Set STLINK_PATH to the installed STM32_Programmer_CLI.exe.`);
      }
      const output = await runCommand(cli, ["-l"]);
      const candidates = parseStlinkCandidates(output);
      session.hardware = { discoveredAt: new Date().toISOString(), candidates };
      session.phase = "DISCOVER_HARDWARE";
      recordEvent(session, "hardware_discovered", { candidates, projectMcu: session.project.mcu });
      return JSON.stringify({
        session_id: session.id,
        phase: session.phase,
        expected_mcu: session.project.mcu,
        candidates,
        selection_required: candidates.length !== 1,
        raw_output: output
      }, null, 2);
    }

    case "stm32_flash_session": {
      const session = sessions.get(args.session_id);
      if (!session) throw new Error(`Unknown session: ${args.session_id}`);
      if (!verifyFlashAuthorization(session, args.authorization_token, args.candidate_id)) {
        throw new Error("Flash authorization is missing, expired, or does not match the selected artifact and ST-Link candidate");
      }
      const result = await flashSessionArtifact(session, args.candidate_id);
      session.phase = "RUN_AND_OBSERVE";
      recordEvent(session, "flash_verified", { artifact: session.artifact, candidateId: args.candidate_id });
      return JSON.stringify({ session_id: session.id, phase: session.phase, flash_output: result }, null, 2);
    }
    // 编译烧录
    case "stm32_build":
      return await runScript("build.bat", [
        args?.project_path || "",
        args?.rebuild ? "rebuild" : ""
      ]);

    case "stm32_flash":
      if (!args?.firmware_path) {
        throw new Error("firmware_path is required. Use stm32_artifact_select and stm32_flash_session for a verified session flash.");
      }
      return await runScript("flash.bat", [args?.firmware_path || ""]);

    // 串口监控
    case "stm32_serial_start":
      return await startSerialMonitor(args?.com_port, args?.baud_rate);

    case "stm32_serial_stop":
      return await stopSerialMonitor();

    case "stm32_serial_read": {
      const lines = state.getSerialLines(args?.lines || 50);
      if (lines.length === 0) {
        return "缓冲区为空，请先启动串口监控 (stm32_serial_start)";
      }
      return lines.map(l =>
        `[${l.timestamp}] ${l.data}`
      ).join('\n');
    }

    case "stm32_serial_search": {
      const results = state.searchSerial(args.keyword);
      if (results.length === 0) {
        return `未找到包含 "${args.keyword}" 的数据`;
      }
      return `找到 ${results.length} 条匹配:\n` +
        results.slice(-20).map(l =>
          `[${l.timestamp}] ${l.data}`
        ).join('\n');
    }

    // 寄存器分析
    case "stm32_reg_read":
      return await runScript("reg_read.bat", [args.peripheral]);

    case "stm32_reg_explain": {
      // 先读取寄存器原始值
      const rawOutput = await runScript("reg_read.bat", [args.peripheral]);

      // 解析输出并添加解读
      const lines = rawOutput.split('\n');
      const explained = lines.map(line => {
        // 匹配格式: "寄存器名 [+偏移]: 值 ; 注释"
        const match = line.match(/^(\w+)\s*\[.*?\]:\s*(0x[0-9a-fA-F]+|\d+)/);
        if (match) {
          const regName = match[1];
          const value = parseInt(match[2], match[2].startsWith('0x') ? 16 : 10);
          return explainRegister(args.peripheral, regName, value);
        }
        return line;
      });

      return explained.join('\n');
    }

    // 内存和变量
    case "stm32_mem_read":
      return await runScript("mem_monitor.bat", [
        args.address,
        String(args?.size || 4),
        "1"
      ]);

    case "stm32_watch_var":
      return await runScript("watch_var.bat", [args.variable_name]);

    // 一键调试
    case "stm32_debug_cycle": {
      return "The legacy debug cycle no longer flashes automatically. Start a session with stm32_feature_deliver, build with stm32_session_build, select the explicit artifact, discover hardware, then use stm32_flash_authorize and stm32_flash_session.";

      const results = [];

      // Step 1: 编译
      results.push("=== Step 1: 编译 ===");
      try {
        const buildResult = await runScript("build.bat", [args?.project_path || ""]);
        results.push(buildResult);
      } catch (e) {
        results.push(`编译失败: ${e.message}`);
        return results.join('\n');
      }

      // Step 2: 烧录
      results.push("\n=== Step 2: 烧录 ===");
      try {
        const flashResult = await runScript("flash.bat", [""]);
        results.push(flashResult);
      } catch (e) {
        results.push(`烧录失败: ${e.message}`);
        return results.join('\n');
      }

      // Step 3: 启动串口监控
      results.push("\n=== Step 3: 串口监控 ===");
      try {
        const serialResult = await startSerialMonitor(args?.com_port, args?.baud_rate);
        results.push(serialResult);
      } catch (e) {
        results.push(`串口启动失败: ${e.message}`);
      }

      results.push("\n=== 调试循环已启动 ===");
      results.push("使用 stm32_serial_read 读取串口数据");
      results.push("使用 stm32_reg_read 读取寄存器状态");

      return results.join('\n');
    }

    // 状态查询
    case "stm32_status": {
      const status = {
        serial: {
          running: state.serialMonitor !== null,
          bufferSize: state.serialBuffer.length,
          linesReceived: state.stats.serialLines,
          errors: state.stats.errors
        },
        watches: {
          count: state.watches.size,
          items: Array.from(state.watches.entries()).map(([id, w]) => ({
            id,
            expression: w.expression,
            lastValue: w.lastValue
          }))
        },
        sessions: {
          count: sessions.size,
          items: Array.from(sessions.values()).map(sessionSummary)
        }
      };
      return JSON.stringify(status, null, 2);
    }

    default:
      throw new Error(`未知工具: ${name}`);
  }
}

// ==================== MCP Server ====================
const server = new Server(
  { name: "stm32-tools", version: "2.0.0" },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => ({
  tools: TOOLS
}));

server.setRequestHandler(CallToolRequestSchema, async (req) => {
  try {
    const { name, arguments: args } = req.params;
    const result = await handleToolCall(name, args);
    return {
      content: [{ type: "text", text: result }]
    };
  } catch (error) {
    return {
      content: [{ type: "text", text: `错误: ${error.message}` }],
      isError: true
    };
  }
});

// ==================== 启动 ====================
async function main() {
  await server.connect(new StdioServerTransport());
  console.error("STM32 MCP Tools v2.0 已启动");
  console.error(`工具目录: ${TOOLS_DIR}`);
  console.error(`默认串口: ${DEFAULT_SERIAL_PORT} @ ${DEFAULT_SERIAL_BAUD}bps`);
}

main().catch(console.error);
