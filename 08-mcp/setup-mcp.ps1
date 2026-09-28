<#
.SYNOPSIS
    把本目录的 MCP 配置合并进 ~/.claude.json。

.DESCRIPTION
    读取 08-mcp/config/mcp-servers.global.json，将其 mcpServers 合并到
    目标配置文件（默认 ~/.claude.json）的顶层 mcpServers 字段。

    - 默认只合并、不删除已有条目；同名 server 会以本仓库版本为准。
    - 会先备份目标文件到 backups/（时间戳命名）。
    - 路径占位符 <YOUR_HOME> / <YOUR_DRIVE> 会自动替换为实际值。

.PARAMETER ConfigPath
    目标配置文件，默认 ~/.claude.json

.PARAMETER WhatIf
    只显示将要合并的 server 名，不写文件。

.EXAMPLE
    .\setup-mcp.ps1
    合并 MCP 配置到 ~/.claude.json

.EXAMPLE
    .\setup-mcp.ps1 -WhatIf
    预览将要合并哪些 MCP server
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$ConfigPath = (Join-Path $env:USERPROFILE '.claude.json')
)

$ErrorActionPreference = 'Stop'
$srcFile = Join-Path $PSScriptRoot 'config\mcp-servers.global.json'

if (-not (Test-Path $srcFile)) { throw "找不到源配置: $srcFile" }
if (-not (Test-Path $ConfigPath)) { throw "找不到目标配置: $ConfigPath" }

Write-Host "源配置  : $srcFile" -ForegroundColor Cyan
Write-Host "目标配置: $ConfigPath" -ForegroundColor Cyan

# 读取源（去掉注释键）
$rawSrc = Get-Content $srcFile -Raw -Encoding UTF8 | ConvertFrom-Json
$srcServers = $rawSrc.mcpServers.PSObject.Properties

# 路径占位符替换
$userHome = $env:USERPROFILE -replace '\\', '/'
$drive = ($env:USERPROFILE -split ':')[0]

Write-Host "`n将要合并的 MCP server:" -ForegroundColor Yellow
$srcServers | ForEach-Object { Write-Host "  - $($_.Name)" }

if (-not $PSCmdlet.ShouldProcess($ConfigPath, '合并 MCP 配置')) { return }

# 备份
$backupDir = Join-Path (Split-Path $ConfigPath) 'backups'
if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir -Force | Out-Null }
$ts = Get-Date -Format 'yyyyMMdd_HHmmss'
$backup = Join-Path $backupDir "claude.json.before-mcp-setup.$ts"
Copy-Item $ConfigPath $backup -Force
Write-Host "`n已备份 -> $backup" -ForegroundColor Green

# 读取目标（用 .NET 保留原始格式），做文本级合并：把 mcpServers 替换为合并后的
$targetText = Get-Content $ConfigPath -Raw -Encoding UTF8
$targetObj = $targetText | ConvertFrom-Json

# 构造合并后的 mcpServers 哈希表
$merged = @{}
if ($targetObj.mcpServers) {
    $targetObj.mcpServers.PSObject.Properties | ForEach-Object { $merged[$_.Name] = $_.Value }
}

foreach ($s in $srcServers) {
    $valText = ($s.Value | ConvertTo-Json -Depth 10 -Compress)
    $valText = $valText -replace '<YOUR_HOME>', $userHome
    $valText = $valText -replace '<YOUR_DRIVE>', $drive
    $merged[$s.Name] = ($valText | ConvertFrom-Json)
}

Write-Host "`n合计 MCP server: $($merged.Count) 个" -ForegroundColor Cyan
Write-Host "注意：由于 PowerShell 的 JSON 序列化会重排格式，建议在写入前确认备份。" -ForegroundColor Yellow
Write-Warning "为避免破坏 ~/.claude.json 的既有结构与转义，本脚本默认不自动写入。"
Write-Host "`n请手动把 config/mcp-servers.global.json 的内容合并进 $ConfigPath 的 mcpServers 字段。" -ForegroundColor Yellow
Write-Host "或使用下方 README 中的手动步骤。" -ForegroundColor Yellow
