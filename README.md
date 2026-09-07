# Browser Kit

Headless browser-use MCP kits for sandboxed coding agents.

## Codex

The Codex variant installs Chromium and Playwright MCP, then registers the MCP
server as `browser-use`. Browser profiles are ephemeral and all browser state
stays inside the sandbox.

```console
sbx run codex --kit ghcr.io/dvdksn/browser-kit:codex .
```

To use the local source:

```console
sbx run codex --kit ./codex .
```

Ask Codex to use the browser tools when a task needs a website, for example:

```text
Use the browser-use tools to open https://example.com and report the page title.
```

The kit grants network access only to package and browser-download hosts needed
during installation. Websites remain governed by the sandbox's network policy.

## Variants

Each agent integration lives in its own directory and is published under an
agent-specific OCI tag:

| Agent | Source | OCI reference |
| --- | --- | --- |
| Codex | `codex/` | `ghcr.io/dvdksn/browser-kit:codex` |

Pushes to `main` publish each variant through the matrix in
`.github/workflows/publish.yml`. To publish the Codex variant manually:

```console
sbx kit push ./codex ghcr.io/dvdksn/browser-kit:codex
```
