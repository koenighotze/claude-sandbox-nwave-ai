#!/bin/bash
set -euo pipefail

NWAVE_DIR="/opt/nwave/.claude"
CLAUDE_HOME="/home/claude"

mkdir -p "${CLAUDE_HOME}/.claude"
for dir in agents skills tasks templates; do
    src="${NWAVE_DIR}/${dir}"
    target="${CLAUDE_HOME}/.claude/${dir}"
    if [ ! -d "${src}" ]; then
        echo "WARNING: nWave source directory not found, skipping: ${src}" >&2
        continue
    fi
    if [ ! -e "${target}" ]; then
        ln -s "${src}" "${target}"
    fi
done

exec claude --enable-auto-mode "$@"
