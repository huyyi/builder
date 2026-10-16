# builder

每个镜像放在一个独立目录，目录内包含 `Dockerfile`（例如 `nginx/Dockerfile`）。

仓库已配置 GitHub Actions 工作流：当 `*/Dockerfile` 发生变更时，会自动构建并推送镜像到 GHCR，镜像命名格式为：

- `ghcr.io/<owner>/<repo>-<目录名>:latest`
- `ghcr.io/<owner>/<repo>-<目录名>:sha-<commit_sha>`
