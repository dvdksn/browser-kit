# Browser Kit

Headless browser-use MCP kits for sandboxed coding agents.

This branch uses the [v3 kit format](https://github.com/docker/runtime-kits/blob/main/docs/spec/SPEC-v3.md).
The `main` branch and `codex` image tag use v2.

## Codex

The Codex mixin ships Chromium, Playwright MCP, and a launcher in its image.
An install hook registers the MCP server as `browser-use`. Browser profiles
are ephemeral and all browser state stays inside the sandbox.

Use an `sbx` build with v3 support and a v3 workload, with either Codex built
in and declared in `provides`, or a separate mixin that provides `codex`.
The browser overlay targets the Debian 13 Docker shell template pinned in
`codex/spec.dockerfile`; use a workload based on that template. It is not a
portable overlay for arbitrary Linux distributions.

After the publishing workflow succeeds, add the published browser kit to your
v3 workload and Codex kit:

```console
sbx run <workload-kit> --kit <codex-kit> \
  --kit ghcr.io/dvdksn/browser-kit:codex-v3 .
```

Replace the angle-bracket placeholders with your v3 kit references. Omit
`--kit <codex-kit>` if the workload itself provides `codex`. A built-in v2
`codex` agent cannot be composed with this v3 mixin.

For a local example using the shell workload and Codex mixin from
`docker/runtime-kits`, clone that repository beside this one, then run from
this repository:

```console
sbx run ../runtime-kits/examples/shell \
  --kit ../runtime-kits/examples/codex --kit ./codex .
```

The example workload starts a shell. Run `codex` inside it and ask:

```text
Use the browser-use tools to open https://example.com and report the page title.
```

Package and browser downloads happen during the image build. The kit requests
no additional sandbox network access. Websites remain governed by the
sandbox's network policy; permit the sites your task needs through that policy.
The launcher retains Chromium's sandbox, isolated profiles, blocked service
workers, and sandbox-local output under `/tmp/browser-use`.

## Build and publish

Each agent integration lives in its own directory:

| Agent | Descriptor | OCI reference |
| --- | --- | --- |
| Codex | `codex/spec.yaml` | `ghcr.io/dvdksn/browser-kit:codex-v3` |

Build locally to validate the descriptor and its content recipe:

```console
docker buildx build ./codex -f ./codex/spec.yaml -t browser-kit:codex-v3 --load
```

A locally loaded image is useful for inspection. Use the source directory with
`sbx` for local iteration, or push the image to a registry for consumption by
reference. The mixin image contains an overlay, not a standalone operating
system.

Pushes to `v3` publish the `codex-v3` tag through
`.github/workflows/publish.yml`. The workflow builds both `linux/amd64` and
`linux/arm64` using the v3 BuildKit frontend, which validates the descriptor
and adds its OCI annotations. To publish manually with a builder configured
for both architectures:

```console
docker buildx build ./codex -f ./codex/spec.yaml \
  --platform linux/amd64,linux/arm64 \
  -t ghcr.io/dvdksn/browser-kit:codex-v3 --push
```

## Source layout

- `codex/spec.yaml`: composition dependency, MCP registration, and agent context.
- `codex/spec.dockerfile`: pinned template base and Playwright versions, browser
  dependencies, environment, and launcher installation.
- `codex/browser-use-mcp`: isolated headless Chromium launcher.
- `codex/agent-context.md`: browser tool instructions packaged with the image.
