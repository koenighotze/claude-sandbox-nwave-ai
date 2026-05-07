# checkov:skip=CKV_DOCKER_7:Base image versioning deferred to upstream koenighotze/claude-sandbox
FROM ghcr.io/koenighotze/claude-sandbox:latest

ARG NWAVE_REF=main

USER root

RUN uv pip install --system --break-system-packages nwave-ai

RUN git clone --depth=1 --branch "${NWAVE_REF}" \
        https://github.com/nWave-ai/nWave /tmp/nwave && \
    mkdir -p /opt/nwave/.claude && \
    cp -r /tmp/nwave/nWave/agents    /opt/nwave/.claude/ && \
    cp -r /tmp/nwave/nWave/skills    /opt/nwave/.claude/ && \
    cp -r /tmp/nwave/nWave/tasks     /opt/nwave/.claude/ && \
    cp -r /tmp/nwave/nWave/templates /opt/nwave/.claude/ && \
    rm -rf /tmp/nwave

ENV CHUB_TELEMETRY=0

RUN npm install -g @aisuite/chub && \
    cp "$(npm root -g)/@aisuite/chub/skills/get-api-docs/SKILL.md" \
       /opt/nwave/.claude/skills/get-api-docs.md

COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

USER claude
WORKDIR /project
ENTRYPOINT ["entrypoint.sh"]
CMD []
HEALTHCHECK NONE
