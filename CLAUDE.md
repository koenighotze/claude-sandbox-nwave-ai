# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository extends the [koenighotze/claude-sandbox](https://github.com/koenighotze/claude-sandbox) Docker image with the [nWave AI framework](https://github.com/nWave-ai/nWave). It builds a Docker image with Claude Code and the full nWave agent/skill/command suite pre-installed, and mounts a local project directory into the container.

## Commands

**Build the image:**
```bash
./build.sh
```
Builds the image tagged as `claude-sandbox-nwave-ai:dev`.

**Run the sandbox:**
```bash
./run.sh [project-dir]
```
Mounts `project-dir` (defaults to `$PWD`) into the container at `/project` and launches Claude Code interactively. The container is named `claude-sandbox-nwave-ai`.

**Remove the container:**
```bash
./rm.sh
```
Force-removes a stopped `claude-sandbox-nwave-ai` container.

## Architecture

- `Dockerfile` — Extends `ghcr.io/koenighotze/claude-sandbox:latest`. Installs the `nwave-ai` CLI system-wide via `uv pip install --system` and copies nWave agents, skills, commands, and templates into `/opt/nwave/.claude/`.
- `entrypoint.sh` — On first run, symlinks `/opt/nwave/.claude/{agents,skills,tasks,templates}` into `~/.claude/` so Claude Code can discover them. Then `exec claude --enable-auto-mode`.
- `build.sh` — Thin wrapper around `docker build`.
- `run.sh` — Runs the container interactively with bind mounts for the target project (`/project`) and per-project Claude home (`/home/claude`). Accepts an optional path argument; defaults to `$PWD`.
- `rm.sh` — Removes a stopped sandbox container by name.

## nWave assets

nWave assets (agents, skills, slash commands, templates) live in `/opt/nwave/.claude/` inside the image — outside the `/home/claude` volume mount. On first run, `entrypoint.sh` creates symlinks from `~/.claude/` to these system paths. To override a specific agent or skill, replace the symlink with a real directory.

The `NWAVE_REF` build arg controls which branch/tag/SHA of nWave is installed (defaults to `main`):
```bash
docker build --build-arg NWAVE_REF=v3.14.1 -t claude-sandbox-nwave-ai:v3.14.1 .
```
