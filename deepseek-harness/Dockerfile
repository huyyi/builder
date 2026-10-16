FROM node:22-bookworm-slim

ARG DSH_TAG=latest

ENV DEBIAN_FRONTEND=noninteractive \
    DSH_WEB_PORT=3080

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl git caddy openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    git clone --filter=blob:none --no-checkout https://github.com/deepseek-ai/deepseek-harness.git /opt/deepseek-harness; \
    cd /opt/deepseek-harness; \
    if [ "$DSH_TAG" = "latest" ]; then \
      DSH_TAG="$(git tag --sort=-v:refname --list 'dsh-v*' | head -n1)"; \
    fi; \
    test -n "$DSH_TAG"; \
    git checkout "$DSH_TAG"; \
    corepack enable; \
    PNPM_VERSION="$(node -p "require('./package.json').packageManager.split('@')[1]")"; \
    corepack prepare "pnpm@$PNPM_VERSION" --activate; \
    pnpm install --frozen-lockfile; \
    pnpm run build:official; \
    ln -sfn /opt/deepseek-harness/apps/cli/lib/bin.js /usr/local/bin/dsh

RUN useradd --create-home --shell /bin/bash dsh \
    && chown -R dsh:dsh /opt/deepseek-harness

RUN set -eux; \
    runuser -u dsh -- env HOME=/home/dsh dsh plugin --profile web add @linxin666/dsh-web-all@latest; \
    runuser -u dsh -- env HOME=/home/dsh dsh plugin --profile dsh-tui add @deepseek-harness-tui/dsh-tui@latest; \
    runuser -u dsh -- env HOME=/home/dsh dsh plugin --profile web add dsh-full-remote@latest; \
    runuser -u dsh -- env HOME=/home/dsh dsh plugin --profile web add @changfenhuang/dsh-genui@latest; \
    runuser -u dsh -- env HOME=/home/dsh dsh plugin --profile web add github:wingsky-1/dsh-skill-explorer

COPY Caddyfile /etc/caddy/Caddyfile
COPY entrypoint.sh /usr/local/bin/entrypoint
COPY dsh-stack.sh /usr/local/bin/dsh-stack
RUN chmod 755 /usr/local/bin/entrypoint /usr/local/bin/dsh-stack

WORKDIR /home/dsh

EXPOSE 8080 2222

HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD curl -fsS http://127.0.0.1:8080/dsh/ >/dev/null || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint"]
