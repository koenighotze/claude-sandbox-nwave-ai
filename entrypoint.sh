#!/bin/bash
set -euo pipefail

NWAVE_DIR="/opt/nwave/.claude"
CLAUDE_HOME="/home/claude"

mkdir -p "${CLAUDE_HOME}/.claude"
for dir in agents skills tasks templates; do
    target="${CLAUDE_HOME}/.claude/${dir}"
    if [ ! -e "${target}" ]; then
        ln -s "${NWAVE_DIR}/${dir}" "${target}"
    fi
done

exec claude --enable-auto-mode "$@"
