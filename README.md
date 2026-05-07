# claude-sandbox-nwave-ai

[![CI](https://github.com/koenighotze/claude-sandbox-nwave-ai/actions/workflows/ci.yml/badge.svg)](https://github.com/koenighotze/claude-sandbox-nwave-ai/actions/workflows/ci.yml)
[![Publish](https://github.com/koenighotze/claude-sandbox-nwave-ai/actions/workflows/publish.yml/badge.svg)](https://github.com/koenighotze/claude-sandbox-nwave-ai/actions/workflows/publish.yml)
[![Image](https://img.shields.io/badge/ghcr.io-claude--sandbox--nwave--ai-blue?logo=github)](https://github.com/koenighotze/claude-sandbox-nwave-ai/pkgs/container/claude-sandbox-nwave-ai)

A Docker sandbox for [Claude Code](https://claude.ai/code) that extends [koenighotze/claude-sandbox](https://github.com/koenighotze/claude-sandbox) with the [nWave AI framework](https://github.com/nWave-ai/nWave) and [context-hub](https://github.com/andrewyng/context-hub).

---

## What's inside

### Base image — [koenighotze/claude-sandbox](https://github.com/koenighotze/claude-sandbox)

- **Claude Code** (`@anthropic-ai/claude-code`) — the AI coding agent
- **Node.js 25** runtime
- **Rust CLI tools** — lazygit, delta, eza, xh, just, watchexec, hyperfine, sd, dust, procs
- **System tools** — git, gh, fzf, fd, ripgrep, bat, jq, tmux, vim, zsh, semgrep, uv
- **Network tools** — iptables, ipset (via `NET_ADMIN` capability)

### nWave AI framework — [nWave-ai/nWave](https://github.com/nWave-ai/nWave)

A structured AI development methodology delivered as Claude Code agents, skills, and commands:

- **23 agents** — Specialized roles across the full development lifecycle (product discoverer, solution architect, software crafter, acceptance designer, and more)
- **98+ skills** — Domain knowledge modules covering testing, DevOps, architecture, delivery, and more
- **21 slash commands** — `/nw-deliver`, `/nw-design`, `/nw-discover`, and others for structured development waves
- **DES (Deterministic Execution System)** — Audit logging and integrity verification for reproducible AI-assisted workflows
- **`nwave-ai` CLI** — Installation management, health checks, roadmap tooling

### context-hub — [andrewyng/context-hub](https://github.com/andrewyng/context-hub)

Curated, versioned documentation and skills for AI coding agents:

- **`chub` CLI** — Search and fetch up-to-date API docs and SDK references at agent runtime
- **`chub-mcp`** — MCP server variant for direct Claude Code integration
- **`get-api-docs` skill** — Installed into `~/.claude/skills/` for use during coding sessions
- Prevents hallucination and knowledge cutoff issues by supplying current documentation on demand

---

## Quick start

**Build the image:**
```bash
./build.sh
```

**Run against a project:**
```bash
./run.sh /path/to/your/project
```

Defaults to `$PWD` if no path is given. Claude Code launches interactively inside the container with the project mounted at `/project`.

**Stop and remove the container:**
```bash
./rm.sh
```

---

## How it works

```
docker run
  -v /your/project:/project:rw          # your code
  -v /your/project/claude_home:/home/claude:rw   # per-project Claude state
```

The `/home/claude` mount is **per-project** — each project gets its own `claude_home/` directory, keeping Claude's memory, settings, and conversation history isolated.

On first run, `entrypoint.sh` symlinks the nWave and context-hub assets from the image into `~/.claude/`:

```
/opt/nwave/.claude/agents    → ~/.claude/agents
/opt/nwave/.claude/skills    → ~/.claude/skills   (includes chub get-api-docs skill)
/opt/nwave/.claude/tasks     → ~/.claude/tasks
/opt/nwave/.claude/templates → ~/.claude/templates
```

Assets live in `/opt/nwave/` (image layer, outside the volume mount) and are therefore available in every project without duplication. Replacing a symlink with a real directory overrides that asset for the current project only.

---

## Pull the image

```bash
docker pull ghcr.io/koenighotze/claude-sandbox-nwave-ai:latest
```

---

## Build arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `NWAVE_REF` | `main` | Branch, tag, or SHA of nWave to install |

Pin to a specific nWave release:
```bash
docker build --build-arg NWAVE_REF=v3.14.1 -t claude-sandbox-nwave-ai:v3.14.1 .
```

---

## Repository layout

```
├── Dockerfile          # Extends ghcr.io/koenighotze/claude-sandbox
├── entrypoint.sh       # Symlinks nWave/chub assets, then exec claude
├── build.sh            # docker build wrapper
├── run.sh              # docker run wrapper (mounts project + claude home)
├── rm.sh               # force-removes the named container
├── .dockerignore
└── .github/workflows/
    ├── ci.yml          # shellcheck + checkov + build (no push)
    └── publish.yml     # multi-arch push to ghcr.io on main
```

---

## CI / CD

**CI** runs on every pull request and push to `main`:
1. `shellcheck` — lints all shell scripts
2. `checkov` — scans the Dockerfile for security issues
3. Build — verifies the image builds for `linux/amd64`

**Publish** runs on every push to `main`:
- Builds and pushes a multi-arch image (`linux/amd64` + `linux/arm64`) to `ghcr.io/koenighotze/claude-sandbox-nwave-ai`
- Tags: `latest` and short SHA

---

## License

MIT
