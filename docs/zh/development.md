# FastAPI 项目 - 开发

## Docker Compose

* 使用 Docker Compose 启动本地技术栈：

```bash
docker compose watch
```

* 现在你可以打开浏览器并访问以下 URL：

前端，使用 Docker 构建，根据路径处理路由：<http://localhost:5173>

后端，基于 OpenAPI 的 JSON Web API：<http://localhost:8001>

使用 Swagger UI 的自动交互式文档（来自 OpenAPI 后端）：<http://localhost:8001/docs>

Adminer，数据库 Web 管理：<http://localhost:8080>

Traefik UI，查看代理如何处理路由：<http://localhost:8090>

**注意**：第一次启动技术栈时，可能需要一分钟才能准备就绪。因为后端需要等待数据库就绪并配置一切。你可以检查日志来监控。

要检查日志，运行（在另一个终端中）：

```bash
docker compose logs
```

要检查特定服务的日志，添加服务名称，例如：

```bash
docker compose logs backend
```

## Mailcatcher

Mailcatcher 是一个简单的 SMTP 服务器，用于在本地开发期间捕获后端发送的所有邮件。它不会发送真正的邮件，而是捕获并在 Web 界面中显示。

这对于以下场景很有用：

* 在开发期间测试邮件功能
* 验证邮件内容和格式
* 调试邮件相关功能而不发送真正的邮件

在使用 Docker Compose 本地运行时，后端会自动配置使用 Mailcatcher（SMTP 端口 1025）。所有捕获的邮件可以在 <http://localhost:1080> 查看。

## 本地开发

Docker Compose 文件配置为每个服务在 `localhost` 的不同端口上可用。

对于后端和前端，它们使用与其本地开发服务器相同的端口，因此后端在 `http://localhost:8001`，前端在 `http://localhost:5173`。

这样，你可以关闭 Docker Compose 中的某个服务并启动其本地开发服务器，一切仍然正常工作，因为它们都使用相同的端口。

例如，你可以停止 Docker Compose 中的 `frontend` 服务，在另一个终端中运行：

```bash
docker compose stop frontend
```

然后启动本地前端开发服务器：

```bash
bun run dev
```

或者你可以停止 `backend` Docker Compose 服务：

```bash
docker compose stop backend
```

然后你可以运行后端的本地开发服务器：

```bash
cd backend
fastapi dev app/main.py
```

## 在 `localhost.tiangolo.com` 中使用 Docker Compose

当你启动 Docker Compose 技术栈时，默认使用 `localhost`，每个服务使用不同的端口（后端、前端、adminer 等）。

当你部署到生产环境（或 staging）时，它会在不同的子域名上部署每个服务，如 `api.example.com` 用于后端，`dashboard.example.com` 用于前端。

在关于[部署](deployment.md)的指南中，你可以了解 Traefik，即已配置的代理。它是负责根据子域名将流量传输到每个服务的组件。

如果你想在本地测试一切是否正常，你可以编辑本地 `.env` 文件，将：

```dotenv
DOMAIN=localhost.tiangolo.com
```

这将由 Docker Compose 文件用于配置服务的基础域名。

Traefik 将使用它将 `api.localhost.tiangolo.com` 的流量传输到后端，将 `dashboard.localhost.tiangolo.com` 的流量传输到前端。

域名 `localhost.tiangolo.com` 是一个特殊的域名，它（及其所有子域名）被配置为指向 `127.0.0.1`。这样你可以将其用于本地开发。

更新后，再次运行：

```bash
docker compose watch
```

在部署时，例如在生产环境中，主要的 Traefik 配置在 Docker Compose 文件之外。对于本地开发，`compose.override.yml` 中包含了一个 Traefik，只是为了让你测试域名是否按预期工作，例如使用 `api.localhost.tiangolo.com` 和 `dashboard.localhost.tiangolo.com`。

## Docker Compose 文件和环境变量

有一个主要的 `compose.yml` 文件，包含适用于整个技术栈的所有配置，它会被 `docker compose` 自动使用。

还有一个 `compose.override.yml`，包含开发环境的覆盖配置，例如将源代码作为卷挂载。它会被 `docker compose` 自动使用，以在 `compose.yml` 的基础上应用覆盖。

这些 Docker Compose 文件使用 `.env` 文件中包含的配置，这些配置将作为环境变量注入到容器中。

它们还使用一些从脚本中设置的额外配置，这些配置在调用 `docker compose` 命令之前通过环境变量设置。

更改变量后，确保重启技术栈：

```bash
docker compose watch
```

## .env 文件

`.env` 文件包含你所有的配置、生成的密钥和密码等。

根据你的工作流，你可能希望将其从 Git 中排除，例如如果你的项目是公开的。在这种情况下，你需要确保设置一种方式，让你的 CI 工具在构建或部署项目时获取它。

一种方法是将每个环境变量添加到你的 CI/CD 系统中，并更新 `compose.yml` 文件以读取特定的环境变量而不是读取 `.env` 文件。

## Pre-commit 和代码 lint

我们使用一个名为 [prek](https://prek.j178.dev/) 的工具（[Pre-commit](https://pre-commit.com/) 的现代替代品）进行代码 lint 和格式化。

当你安装它后，它会在 git 提交之前运行。这样它确保代码在提交之前就是一致且格式化的。

你可以在项目根目录找到一个 `.pre-commit-config.yaml` 文件，其中包含配置。

#### 安装 prek 以自动运行

`prek` 已经是项目依赖的一部分。

安装并确保 `prek` 工具可用后，你需要将其"安装"到本地仓库中，以便它在每次提交之前自动运行。

使用 `uv`，你可以这样做（确保你在 `backend` 文件夹中）：

```bash
❯ uv run prek install -f
prek installed at `../.git/hooks/pre-commit`
```

`-f` 标志强制安装，以防之前已经安装了 `pre-commit` 钩子。

现在每当你尝试提交时，例如使用：

```bash
git commit
```

...prek 将运行并检查和格式化你将要提交的代码，并要求你在提交之前再次使用 git 添加（暂存）该代码。

然后你可以再次 `git add` 修改/修复的文件，现在就可以提交了。

#### 手动运行 prek 钩子

你也可以在所有文件上手动运行 `prek`，可以使用 `uv` 运行：

```bash
❯ uv run prek run --all-files
check for added large files..............................................Passed
check toml...............................................................Passed
check yaml...............................................................Passed
fix end of files.........................................................Passed
trim trailing whitespace.................................................Passed
ruff.....................................................................Passed
ruff-format..............................................................Passed
biome check..............................................................Passed
```

## URL

生产或 staging URL 将使用相同的路径，但使用你自己的域名。

### 开发 URL

开发 URL，用于本地开发。

前端：<http://localhost:5173>

后端：<http://localhost:8001>

自动交互式文档 (Swagger UI)：<http://localhost:8001/docs>

自动替代文档 (ReDoc)：<http://localhost:8001/redoc>

Adminer：<http://localhost:8080>

Traefik UI：<http://localhost:8090>

MailCatcher：<http://localhost:1080>

### 配置了 `localhost.tiangolo.com` 的开发 URL

开发 URL，用于本地开发。

前端：<http://dashboard.localhost.tiangolo.com>

后端：<http://api.localhost.tiangolo.com>

自动交互式文档 (Swagger UI)：<http://api.localhost.tiangolo.com/docs>

自动替代文档 (ReDoc)：<http://api.localhost.tiangolo.com/redoc>

Adminer：<http://localhost.tiangolo.com:8080>

Traefik UI：<http://localhost.tiangolo.com:8090>

MailCatcher：<http://localhost.tiangolo.com:1080>
