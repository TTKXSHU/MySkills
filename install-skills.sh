#!/usr/bin/env bash
# 从本仓库安装 skills 到本地 agent 的 skills 目录（自动压平分类层级）。
#
# 用法：
#   ./install-skills.sh                          # 安装全部到 ~/.claude/skills
#   ./install-skills.sh -d /custom/skills        # 指定目标目录
#   ./install-skills.sh -c 05-knowledge          # 只安装指定分类（可多次）
#   ./install-skills.sh -f                       # 覆盖已存在的同名 skill
#   ./install-skills.sh -n                       # 试运行，只显示不复制

set -euo pipefail

DEST="${HOME}/.claude/skills"
FORCE=0
DRYRUN=0
declare -a CATS=()

while getopts "d:c:fn" opt; do
  case $opt in
    d) DEST="$OPTARG" ;;
    c) CATS+=("$OPTARG") ;;
    f) FORCE=1 ;;
    n) DRYRUN=1 ;;
    *) echo "用法: $0 [-d 目标目录] [-c 分类] [-f] [-n]" >&2; exit 1 ;;
  esac
done

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "仓库根目录: $REPO_ROOT"
echo "目标目录  : $DEST"

# 收集分类目录
if [ ${#CATS[@]} -gt 0 ]; then
  declare -a DIRS=()
  for c in "${CATS[@]}"; do
    if [ -d "$REPO_ROOT/$c" ]; then DIRS+=("$REPO_ROOT/$c"); else echo "分类不存在: $c" >&2; exit 1; fi
  done
else
  mapfile -t DIRS < <(find "$REPO_ROOT" -maxdepth 1 -type d -name '[0-9][0-9]-*' | sort)
fi

[ ${#DIRS[@]} -eq 0 ] && { echo "未找到分类目录（应形如 01-documents）" >&2; exit 1; }

[ -d "$DEST" ] || { [ $DRYRUN -eq 1 ] || mkdir -p "$DEST"; echo "已创建目标目录"; }

installed=0; skipped=0

for cat in "${DIRS[@]}"; do
  echo ""
  echo "[$(basename "$cat")]"
  for skill in "$cat"/*/; do
    [ -d "$skill" ] || continue
    name="$(basename "$skill")"

    if [ ! -f "$skill/SKILL.md" ]; then
      echo "  跳过 $name：缺少 SKILL.md"; skipped=$((skipped+1)); continue
    fi

    target="$DEST/$name"
    if [ -e "$target" ] && [ $FORCE -eq 0 ]; then
      echo "  跳过 $name：目标已存在（用 -f 覆盖）"; skipped=$((skipped+1)); continue
    fi

    if [ $DRYRUN -eq 1 ]; then
      echo "  [试运行] 将复制 $name -> $target"
    else
      [ -e "$target" ] && rm -rf "$target"
      cp -r "$skill" "$DEST/"
      echo "  ✓ $name"
    fi
    installed=$((installed+1))
  done
done

echo ""
echo "完成：安装 $installed 个，跳过 $skipped 个。"
