# STM32 Feature Delivery Loop

This MCP turns a feature request into an auditable Keil MDK and ST-Link delivery session.

## Normal workflow

1. Call `stm32_feature_deliver` with a Keil project directory and a natural-language feature request.
2. The coordinating agent inspects the project, changes code, and uses `stm32_session_build` for the locked `.uvprojx` project.
3. Call `stm32_artifact_select` with one exact `.hex` or `.bin` produced by that build.
4. Call `stm32_hardware_discover`. It lists candidates only; it never flashes a device.
5. After the selected target is reviewed and user authorization is available, call `stm32_flash_authorize` and then `stm32_flash_session` with the returned token and the selected ST-Link candidate ID.
6. Start serial monitoring or variable observation, compare evidence with the feature acceptance criteria, and repeat code changes until the feature passes or the session is safely blocked.

## Guarantees in this version

- Keil directories with multiple `.uvprojx` files are rejected unless `project_file` is explicit.
- Session artifacts must be explicit `.hex` or `.bin` files inside that session's project root.
- Each selected artifact records a SHA-256 hash in the session evidence directory.
- ST-Link discovery never silently picks among multiple probes.
- A flash token is valid for five minutes and is bound to one session, artifact hash, and probe candidate.
- `stm32_debug_cycle` no longer performs an automatic flash.

## Required local tools

- Keil MDK `UV4.exe`, configured through `KEIL_PATH` when it is not installed at `C:\Keil_v5\UV4\UV4.exe`.
- STM32CubeProgrammer `STM32_Programmer_CLI.exe`, configured through `STLINK_PATH` when it is not installed at the default path.

## Evidence

Every session writes JSONL events and build logs below:

```text
%USERPROFILE%\.claude\stm32-debug-sessions\<session-id>
```

The current MCP configuration launches `C:/Users/25569/.claude/tools/mcp-server.js`, so restarting Codex loads the installed implementation.
