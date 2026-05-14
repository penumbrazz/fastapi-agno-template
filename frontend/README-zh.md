# FastAPI 项目 - 前端

前端使用 [Vite](https://vitejs.dev/)、[React](https://reactjs.org/)、[TypeScript](https://www.typescriptlang.org/)、[TanStack Query](https://tanstack.com/query)、[TanStack Router](https://tanstack.com/router) 和 [Tailwind CSS](https://tailwindcss.com/) 构建。

## 环境要求

- [Bun](https://bun.sh/)（推荐）或 [Node.js](https://nodejs.org/)

## 快速开始

```bash
bun install
bun run dev
```

* 然后在浏览器中打开 http://localhost:5173/。

注意，此实时服务器不是在 Docker 中运行的，它是用于本地开发的，这是推荐的工作流。当你对前端满意后，可以构建前端 Docker 镜像并启动它，以在类似生产环境中进行测试。但每次更改都构建镜像不如使用带热重载的本地开发服务器高效。

查看 `package.json` 文件以查看其他可用选项。

### 移除前端

如果你正在开发一个仅 API 的应用程序并想移除前端，你可以轻松做到：

* 删除 `./frontend` 目录。

* 在 `compose.yml` 文件中，删除整个 `frontend` 服务/部分。

* 在 `compose.override.yml` 文件中，删除整个 `frontend` 和 `playwright` 服务/部分。

完成，你就有了一个无前端（仅 API）的应用程序。🤓

---

如果你想的话，你也可以从以下文件中删除 `FRONTEND` 环境变量：

* `.env`
* `./scripts/*.sh`

但这只是为了清理，保留它们也不会有任何影响。

## 生成客户端

### 自动生成

* 激活后端虚拟环境。
* 从项目顶级目录，运行脚本：

```bash
bash ./scripts/generate-client.sh
```

* 提交更改。

### 手动生成

* 启动 Docker Compose 技术栈。

* 从 `http://localhost/api/v1/openapi.json` 下载 OpenAPI JSON 文件，并将其复制到 `frontend` 目录根目录下的新文件 `openapi.json` 中。

* 要生成前端客户端，运行：

```bash
bun run generate-client
```

* 提交更改。

注意，每次后端更改（更改 OpenAPI schema）时，你应该再次按照这些步骤更新前端客户端。

## 使用远程 API

如果你想使用远程 API，你可以将环境变量 `VITE_API_URL` 设置为远程 API 的 URL。例如，你可以在 `frontend/.env` 文件中设置：

```env
VITE_API_URL=https://api.my-domain.example.com
```

然后，当你运行前端时，它将使用该 URL 作为 API 的基础 URL。

## 代码结构

前端代码结构如下：

* `frontend/src` - 主要的前端代码。
* `frontend/src/assets` - 静态资源。
* `frontend/src/client` - 生成的 OpenAPI 客户端。
* `frontend/src/components` - 前端的各种组件。
* `frontend/src/hooks` - 自定义 hooks。
* `frontend/src/routes` - 前端的各种路由，包含页面。

## 使用 Playwright 进行端到端测试

前端包含使用 Playwright 的初始端到端测试。要运行测试，你需要让 Docker Compose 技术栈运行。使用以下命令启动技术栈：

```bash
docker compose up -d --wait backend
```

然后，你可以使用以下命令运行测试：

```bash
bunx playwright test
```

你也可以在 UI 模式下运行测试，查看浏览器并与之交互：

```bash
bunx playwright test --ui
```

要停止并移除 Docker Compose 技术栈并清理测试中创建的数据，使用以下命令：

```bash
docker compose down -v
```

要更新测试，导航到 tests 目录并修改现有的测试文件或根据需要添加新文件。

有关编写和运行 Playwright 测试的更多信息，请参考官方 [Playwright 文档](https://playwright.dev/docs/intro)。
