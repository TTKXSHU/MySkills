---
name: local-skill-router
description: Use when starting any user request, after installing skills, or when deciding which local skill should handle a task.
---

# 本地 Skill 路由器

## 作用

每次处理用户请求前，优先读取本目录下的 `skills-index.md`，用这个轻量目录表判断应该调用哪个本地 skill，避免每次重新扫描整个 skills 目录。

## 必须流程

1. 读取当前 skill 目录下的 `skills-index.md`。
2. 根据用户请求匹配目录表里的触发条件。
3. 如果有匹配项，先调用最具体、最相关的 skill。
4. 如果没有匹配项，再按普通方式处理。
5. 每次新增、删除、重命名、更新 skill 后，必须同步更新 `skills-index.md`。

## 选择规则

- 领域专用 skill 优先于通用流程 skill。
- STM32 + IO表生成代码，优先用 `iocode` 或 `io2code-flash`，不要直接手工改代码。
- 遇到 bug、编译失败、异常现象，优先用 `systematic-debugging`。
- 新功能、行为变更、方案设计，优先用 `brainstorming`。
- 声称完成、修好、通过前，必须用 `verification-before-completion`。

## 更新目录表

添加新 skill 后，在 `skills-index.md` 增加一行：

- skill 名称
- 触发方式或 slash 命令
- 适用场景
- 注意事项

除非目录表缺失或明显过期，否则不要重新扫描所有 skills。
