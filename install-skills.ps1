<#
.SYNOPSIS
    从本仓库的 skills/ 目录安装 skill 到本地 agent 的 skills 目录（自动压平分类层级）。

.DESCRIPTION
    本仓库的 skills/ 下按分类（01-documents/ 等）组织，但 agent 通常要求 skill 直接位于
    skills/ 根目录下。此脚本会遍历所有分类目录，把每个 skill 压平复制过去。

.PARAMETER Destination
    目标 skills 目录。默认 ~/.claude/skills（cc-switch 亦使用此目录）。

.PARAMETER Only
    只安装指定分类，例如 -Only 05-knowledge。省略则安装全部。

.PARAMETER WhatIf
    只显示将要执行的操作，不实际复制。

.EXAMPLE
    .\install-skills.ps1
    安装全部 skill 到 ~/.claude/skills

.EXAMPLE
    .\install-skills.ps1 -Only 05-knowledge,04-code-quality
    只安装「学习」和「代码质量」两个分类

.EXAMPLE
    .\install-skills.ps1 -Destination "D:\backup\skills" -Force
    安装到自定义目录并覆盖同名 skill
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Destination = (Join-Path $env:USERPROFILE '.claude\skills'),
    [string[]]$Only,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$repoRoot = Join-Path $PSScriptRoot 'skills'

Write-Host "仓库根目录: $repoRoot" -ForegroundColor Cyan
Write-Host "目标目录  : $Destination" -ForegroundColor Cyan

# 校验仓库结构
$categories = Get-ChildItem $repoRoot -Directory |
    Where-Object { $_.Name -match '^\d{2}-' } |
    Sort-Object Name

if (-not $categories) {
    throw "未找到分类目录（应形如 skills/01-documents）。请确认脚本位于仓库根目录。"
}

if ($Only) {
    $categories = $categories | Where-Object { $Only -contains $_.Name }
    if (-not $categories) { throw "指定的分类不存在: $($Only -join ', ')" }
}

if (-not (Test-Path $Destination)) {
    if ($PSCmdlet.ShouldProcess($Destination, '创建目录')) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
        Write-Host "已创建目标目录" -ForegroundColor Green
    }
}

$installed = 0
$skipped = 0

foreach ($cat in $categories) {
    Write-Host "`n[$($cat.Name)]" -ForegroundColor Yellow

    foreach ($skill in (Get-ChildItem $cat.FullName -Directory | Sort-Object Name)) {
        $skillMd = Join-Path $skill.FullName 'SKILL.md'
        if (-not (Test-Path $skillMd)) {
            Write-Warning "  跳过 $($skill.Name)：缺少 SKILL.md"
            $skipped++
            continue
        }

        $target = Join-Path $Destination $skill.Name

        if ((Test-Path $target) -and -not $Force) {
            Write-Warning "  跳过 $($skill.Name)：目标已存在（用 -Force 覆盖）"
            $skipped++
            continue
        }

        if ($PSCmdlet.ShouldProcess($target, '复制 skill')) {
            if ((Test-Path $target) -and $Force) {
                Remove-Item $target -Recurse -Force
            }
            Copy-Item $skill.FullName -Destination $Destination -Recurse -Force
            Write-Host "  ✓ $($skill.Name)" -ForegroundColor Green
            $installed++
        }
    }
}

Write-Host "`n完成：安装 $installed 个，跳过 $skipped 个。" -ForegroundColor Cyan
