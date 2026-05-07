#!/bin/bash
set -euo pipefail

DOCKER_BUILDKIT=1 docker build -t "claude-sandbox-nwave-ai:dev" .
