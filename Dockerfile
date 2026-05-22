FROM koenighotze/claude-sandbox:3fc2653@sha256:05fb89ef728270a7a3b6af82994a424133eb42716873a50be43c27c72ce5b931

ARG NWAVE_REF=main

USER root

COPY requirements.txt /tmp/requirements.txt
RUN uv pip install --system --break-system-packages -r /tmp/requirements.txt && \
    git clone --depth=1 --branch "${NWAVE_REF}" \
        https://github.com/nWave-ai/nWave /tmp/nwave && \
    mkdir -p /opt/nwave/.claude && \
    cp -r /tmp/nwave/nWave/agents    /opt/nwave/.claude/ && \
    cp -r /tmp/nwave/nWave/skills    /opt/nwave/.claude/ && \
    cp -r /tmp/nwave/nWave/tasks     /opt/nwave/.claude/ && \
    cp -r /tmp/nwave/nWave/templates /opt/nwave/.claude/ && \
    rm -rf /tmp/nwave /tmp/requirements.txt

ENV CHUB_TELEMETRY=0

RUN npm install -g @aisuite/chub@0.1.4 && \
    cp "$(npm root -g)/@aisuite/chub/skills/get-api-docs/SKILL.md" \
       /opt/nwave/.claude/skills/get-api-docs.md

COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

USER claude
WORKDIR /project
ENTRYPOINT ["entrypoint.sh"]
CMD []
HEALTHCHECK --interval=30s --timeout=5s --retries=1 \
  CMD which claude > /dev/null 2>&1 || exit 1
