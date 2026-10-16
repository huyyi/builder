# builder

每个镜像放在一个独立目录，目录内包含 `Dockerfile`（例如 `nginx/Dockerfile`）。

仓库已配置 GitHub Actions 工作流：当 `*/Dockerfile` 发生变更时，会自动构建并推送镜像到 GHCR，镜像命名格式为：

- `ghcr.io/<owner>/<repo>-<目录名>:latest`
- `ghcr.io/<owner>/<repo>-<目录名>:sha-<commit_sha>`

## deepseek-harness

新增 `deepseek-harness/` 镜像目录，用于从源码构建 `dsh`，并通过内置 Caddy 反向代理暴露 Web UI：

- Caddy 将根路径请求直接反代到 `dsh web`
- 默认对 `/` 与 `/index.html` 禁缓存，并对 `/assets/*` 设置长期缓存
- 支持 SSH 调试/开发（默认开启，监听 `2222`），可通过 `ENABLE_SSH=false` 关闭
  - `DSH_SSH_AUTHORIZED_KEYS`：注入公钥（推荐）
  - `DSH_SSH_PASSWORD`：为 `dsh` 用户设置密码并启用密码登录
  - `DSH_SSH_PORT`：自定义 SSH 端口（默认 `2222`）
- 镜像构建时会预装以下插件：
  - `zhu1090093659/dsh-web`（`@linxin666/dsh-web-all`，web profile）
  - `PerryLink/dsh-plugin-guide`（`dsh-plugin-guide`，web profile）
  - `@linxin666/dsh-client-ui-skill-explorer`（`@linxin666/dsh-client-ui-skill-explorer`，web profile）
  - `ccch1mneyyy/dsh-TUI`（`@deepseek-harness-tui/dsh-tui`，dsh-tui profile）
  - `JUANWANG-BUAA/dsh-full-remote`（`dsh-full-remote`，web profile）
  - `omdsh-dev/dsh-genui`（`@changfenhuang/dsh-genui`，web profile）
  - `wingsky-1/dsh-skill-explorer`（GitHub 安装，web profile）
  - `rongxingda/dsh-prompt-enhance`（`dsh-prompt-enhance`，web profile）
