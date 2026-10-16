# builder

每个镜像放在一个独立目录，目录内包含 `Dockerfile`（例如 `nginx/Dockerfile`）。

仓库已配置 GitHub Actions 工作流：当 `*/Dockerfile` 发生变更时，会自动构建并推送镜像到 GHCR，镜像命名格式为：

- `ghcr.io/<owner>/<repo>-<目录名>:latest`
- `ghcr.io/<owner>/<repo>-<目录名>:sha-<commit_sha>`

## deepseek-harness

新增 `deepseek-harness/` 镜像目录，用于从源码构建 `dsh`，并通过内置 Caddy 反向代理提供路径前缀兼容：

- 访问根路径 `/` 会自动重定向到 `/dsh/`
- `/dsh/*` 会转发到 `dsh web`
- 同时兼容误发到根路径的 `/api/*`、`/assets/*` 等请求，避免在路径前缀代理场景下出现 404
