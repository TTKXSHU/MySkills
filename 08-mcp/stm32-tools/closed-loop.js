"use strict";

const crypto = require("crypto");
const fs = require("fs");
const path = require("path");

const EVIDENCE_ROOT = process.env.STM32_EVIDENCE_ROOT || path.join(process.env.USERPROFILE, ".claude", "stm32-debug-sessions");
const FLASH_AUTH_TTL_MS = 5 * 60 * 1000;

function requireDirectory(directory) {
  const resolved = path.resolve(directory);
  if (!fs.existsSync(resolved) || !fs.statSync(resolved).isDirectory()) {
    throw new Error(`Project directory does not exist: ${resolved}`);
  }
  return resolved;
}

function findKeilProjects(root) {
  const found = [];
  const walk = (directory) => {
    for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
      if (entry.name === "node_modules" || entry.name.startsWith(".")) continue;
      const entryPath = path.join(directory, entry.name);
      if (entry.isDirectory()) walk(entryPath);
      if (entry.isFile() && entry.name.toLowerCase().endsWith(".uvprojx")) found.push(entryPath);
    }
  };
  walk(root);
  return found;
}

function findRecentArtifacts(root, startedAt) {
  const found = [];
  const walk = (directory) => {
    for (const entry of fs.readdirSync(directory, { withFileTypes: true })) {
      if (entry.name === "node_modules" || entry.name.startsWith(".")) continue;
      const entryPath = path.join(directory, entry.name);
      if (entry.isDirectory()) walk(entryPath);
      if (entry.isFile() && /\.(hex|bin)$/i.test(entry.name) && fs.statSync(entryPath).mtimeMs >= startedAt) {
        found.push(entryPath);
      }
    }
  };
  walk(root);
  return found.sort();
}

function xmlValue(content, tag) {
  const match = content.match(new RegExp(`<${tag}>([^<]+)</${tag}>`, "i"));
  return match ? match[1].trim() : null;
}

function detectKeilProject(projectPath, explicitProjectFile) {
  const root = requireDirectory(projectPath);
  let projects;
  if (explicitProjectFile) {
    const resolved = path.resolve(root, explicitProjectFile);
    if (!resolved.toLowerCase().endsWith(".uvprojx") || !fs.existsSync(resolved)) {
      throw new Error(`Keil project file does not exist: ${resolved}`);
    }
    projects = [resolved];
  } else {
    projects = findKeilProjects(root);
  }
  if (projects.length === 0) throw new Error(`No Keil .uvprojx project found below: ${root}`);
  if (projects.length > 1) {
    throw new Error(`Multiple Keil projects found; specify project_file: ${projects.join(", ")}`);
  }

  const projectFile = projects[0];
  const content = fs.readFileSync(projectFile, "utf8");
  return {
    adapter: "keil-mdk",
    root,
    projectFile,
    target: xmlValue(content, "TargetName"),
    mcu: xmlValue(content, "Device")
  };
}

function digestFile(filePath) {
  const hash = crypto.createHash("sha256");
  hash.update(fs.readFileSync(filePath));
  return hash.digest("hex");
}

function parseStlinkCandidates(output) {
  const serials = new Set();
  const pattern = /ST-LINK\s+SN\s*:\s*([A-Za-z0-9_-]+)/gi;
  let match;
  while ((match = pattern.exec(output)) !== null) serials.add(match[1]);
  return [...serials].map((serial) => ({ id: serial, serial }));
}

function sessionId() {
  return `${new Date().toISOString().replace(/[:.]/g, "-")}-${crypto.randomBytes(4).toString("hex")}`;
}

function createSession({ project, feature = "", evidenceRoot = EVIDENCE_ROOT }) {
  if (!project || !project.projectFile) throw new Error("A detected Keil project is required");
  const id = sessionId();
  const evidenceDir = path.join(path.resolve(evidenceRoot), id);
  fs.mkdirSync(evidenceDir, { recursive: true });
  const session = {
    id,
    phase: "ANALYZE",
    createdAt: new Date().toISOString(),
    feature: String(feature),
    project,
    evidenceDir,
    artifact: null,
    hardware: null,
    authorization: null,
    events: []
  };
  recordEvent(session, "session_started", { projectFile: project.projectFile, target: project.target, mcu: project.mcu });
  return session;
}

function recordEvent(session, type, data = {}) {
  const event = { at: new Date().toISOString(), type, data };
  if (!Array.isArray(session.events)) session.events = [];
  session.events.push(event);
  if (session.evidenceDir) {
    fs.mkdirSync(session.evidenceDir, { recursive: true });
    fs.appendFileSync(path.join(session.evidenceDir, "events.jsonl"), `${JSON.stringify(event)}\n`);
  }
  return event;
}

function setArtifact(session, artifactPath) {
  const resolved = path.resolve(artifactPath);
  const projectRoot = path.resolve(session.project.root) + path.sep;
  if (!resolved.startsWith(projectRoot) || !fs.existsSync(resolved)) {
    throw new Error(`Artifact must exist inside the project directory: ${resolved}`);
  }
  if (!/\.(hex|bin)$/i.test(resolved)) throw new Error(`Unsupported firmware artifact: ${resolved}`);
  session.artifact = { path: resolved, sha256: digestFile(resolved), size: fs.statSync(resolved).size };
  recordEvent(session, "artifact_selected", session.artifact);
  return session.artifact;
}

function issueFlashAuthorization(session, { candidateId }) {
  if (!session.artifact) throw new Error("Select a built firmware artifact before requesting flash authorization");
  if (!candidateId) throw new Error("A selected ST-Link candidate is required");
  const authorization = {
    token: crypto.randomBytes(24).toString("hex"),
    candidateId,
    artifactSha256: session.artifact.sha256,
    expiresAt: Date.now() + FLASH_AUTH_TTL_MS
  };
  session.authorization = authorization;
  session.phase = "WAIT_FLASH_AUTH";
  recordEvent(session, "flash_authorization_issued", { candidateId, artifactSha256: authorization.artifactSha256, expiresAt: new Date(authorization.expiresAt).toISOString() });
  return authorization;
}

function verifyFlashAuthorization(session, token, candidateId) {
  const authorization = session.authorization;
  return Boolean(
    authorization && session.artifact &&
    authorization.token === token &&
    authorization.candidateId === candidateId &&
    authorization.artifactSha256 === session.artifact.sha256 &&
    authorization.expiresAt >= Date.now()
  );
}

function sessionSummary(session) {
  return {
    id: session.id,
    phase: session.phase,
    feature: session.feature,
    project: session.project,
    artifact: session.artifact,
    hardware: session.hardware,
    evidenceDir: session.evidenceDir,
    latestEvent: session.events.at(-1) || null
  };
}

module.exports = {
  createSession,
  detectKeilProject,
  digestFile,
  findRecentArtifacts,
  issueFlashAuthorization,
  parseStlinkCandidates,
  recordEvent,
  setArtifact,
  sessionSummary,
  verifyFlashAuthorization
};
