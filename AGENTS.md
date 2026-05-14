# AGENTS.md

FastAPI Agno Template — FastAPI + React + Agno + CopilotKit 全栈 AI Agent 应用模板。

---

## 📋 项目概览

**多模块架构：**
- **Backend**（FastAPI + SQLModel + Agno + PostgreSQL）：RESTful API、JWT 认证、AI Agent 服务、知识库
- **Frontend**（React 19 + TypeScript + CopilotKit + shadcn/ui）：SPA Web UI + AI 交互界面

**技术栈：**

| 层 | 技术 |
|---|------|
| 后端框架 | FastAPI、SQLModel、Pydantic v2、Alembic |
| AI Agent | Agno（AI Agent 框架）、CopilotKit |
| 知识库 | 向量数据库、RAG 检索增强生成 |
| 数据库 | PostgreSQL 18 |
| 认证 | JWT（HS256）、Argon2 密码哈希 |
| 前端框架 | React 19、TypeScript 5.9、Vite 7 |
| UI | shadcn/ui（new-york 风格）、Tailwind CSS 4、Radix UI |
| 路由/数据 | TanStack Router（文件路由）、TanStack React Query |
| 包管理 | uv（Python）、Bun（JS/TS） |
| 部署 | Docker Compose、Traefik（反向代理 + HTTPS） |

---

## 🧪 测试

**提交前务必运行测试。** 目标覆盖率：最低 40-60%。

**⚠️ Python 模块使用 [uv](https://docs.astral.sh/uv/) 管理依赖。始终使用 `uv run` 执行 Python 命令。**


**测试原则：**
- 遵循 AAA 模式：Arrange（准备）、Act（执行）、Assert（断言）
- Mock 外部服务（Anthropic、OpenAI、Docker、API）
- 测试边缘情况和错误条件
- 保持测试独立和隔离

**E2E 测试规则：**
- ⚠️ E2E 测试不允许优雅失败——禁止 `test.skip()`，禁止静默失败
- ⚠️ 前端禁止 Mock 后端 API——必须发送真实 HTTP 请求
- 如果测试失败，修复问题——绝不能为了通过 CI 而跳过

---
## 💻 代码风格

**⚠️ 所有代码注释必须使用英文编写。**

### 通用原则

- **高内聚，低耦合**：每个模块/类应有单一职责
- **文件大小限制**：如果文件超过 **1000 行**，应拆分为多个子模块
- **函数长度**：每个函数最多 50 行（推荐）

### 代码设计准则

⚠️ **实现新功能或修改现有代码时请遵循以下准则：**

1. **长期可维护性优于短期简洁性**：当存在多种实现方案时，避免那些现在实现简单但长期增加维护成本的方案。选择平衡实现成本和长期可持续性的方案。

2. **使用设计模式进行解耦**：积极考虑应用设计模式（如策略模式、工厂模式、观察者模式、适配器模式）来解耦模块并提高代码灵活性。这使代码库更易于扩展和测试。

3. **通过提取管理复杂性**：如果模块已经很复杂，优先将公共逻辑提取到工具模块或创建新模块，而不是在现有模块上增加更多复杂性。有疑问时，拆分而非扩展。

4. **先参考，再提取，然后复用**：实现新功能之前，务必：
   - 搜索解决类似问题的现有实现
   - 如有发现，从现有代码中提取可复用的模式
   - 创建可在代码库中复用的共享工具
   - 绝不复制粘贴代码或编写重复逻辑

5. **先重构再扩展**：分析代码时，识别与新功能相关的特性。如果存在相关代码，在添加新功能之前先使用设计模式重构并提取公共方法——绝不重新实现已有逻辑。

6. **修复所有发现的问题**：在开发过程中发现问题时，必须立即修复。绝不能因为问题看似"不相关"而忽略——发现的所有 bug 都必须处理。**主动审查**代码和文档中的问题——不要等待用户指出。

7. **优先采用行业标准而非项目惯例**：如果项目有不符行业标准的实践，应采用标准方法而非扩展非标准模式。这提高了代码的可维护性，减少了新开发者的上手难度。

8. **积极删除死代码**：无论需要多大努力，确保删除已废弃、未使用或过时的代码。死代码降低可维护性并造成混乱——保持代码库整洁是不可商量的。

9. **从所有代码中提取公共逻辑**：在进行更改时，如果发现应提取到共享工具的逻辑，立即执行。这适用于所有代码——不仅是"新代码复用旧代码"，也包括从现有代码段之间提取共性。每个复用机会都必须抓住。

10. **避免向后兼容——为理想状态设计**：实现更改时，就像没有遗留负担一样设计——考虑"如果从零开始，最好的方法是什么"。避免为旧逻辑编写兼容性垫片或变通方案。如果向后兼容绝对不可避免，在继续之前先与用户协商。


**📚 文档编写规则：**
- 所有文档文件必须包含 `sidebar_position` 的 frontmatter 用于排序：
  ```markdown
  ---
  sidebar_position: 1
  ---
  ```
- 文档标题不应重复侧边栏分类名称（例如，在 AI 编码分类下使用"概述"而非"AI 编码"）
- 先写中文文档（`docs/zh/`），再创建英文版本（`docs/en/`）
- 使用一致的标题层级：`#` 用于标题，`##` 用于章节，`###` 用于子章节

**📚 详细文档：** 有关设置、测试、架构和用户指南的完整文档，请参阅 `docs/en/` 或 `docs/zh/`。

---


### Python（Backend）

**工具：** Ruff（lint + format）、mypy（类型检查）、ty（备选类型检查）

```bash
cd backend
uv run ruff check --fix .   # lint + 自动修复
uv run ruff format .          # 格式化
uv run mypy backend/app       # 类型检查
```

**规则：**
- Python ≥3.10，遵循 PEP 8
- 必须使用类型提示（mypy strict 模式）
- Ruff lint 规则：E、W、F、I、B、C4、UP、ARG001、T201（禁止 print）
- 描述性命名，公共函数/类必须有 docstring
- 魔法数字提取为常量

### TypeScript/React（Frontend）

**工具：** Biome 2.3（lint + format）、Playwright（E2E）

```bash
cd frontend
bun run format   # 格式化
bun run lint     # lint
```

**规则：**
- TypeScript 严格模式
- 函数式组件，优先 `const` 而非 `let`，禁止 `var`
- 组件名：PascalCase，文件名：kebab-case
- 类型定义放在 `src/types/`
- 双引号、按需分号（Biome 配置）
- **组件复用**：创建新组件前检查 `src/components/ui/`、`src/components/common/`

### 测试属性（data-testid）

- 保留并添加 `data-testid` 属性用于 E2E 测试
- 交互元素（按钮、输入框等）必须添加 `data-testid`
- 命名格式：`{动作}-{元素类型}`（如 `save-button`、`search-input`）

---

## 🔄 Git 工作流

**提交格式：** 约定式提交
```
<type>[scope]: <description>
# 类型：feat | fix | docs | style | refactor | test | chore
# 示例：feat(backend): add user profile API
```

**Pre-commit 钩子：**
- Python：ruff check + ruff format + mypy + ty
- Frontend：biome check
- 自动生成前端 SDK（后端变更时）
- 通用：trailing-whitespace、end-of-file-fixer、check-yaml/toml

**⚠️ 必须遵守 Git 钩子——修复问题，禁止使用 `--no-verify`**

---

## 🔧 后端架构

### 目录结构

```
backend/app/
├── main.py              # FastAPI 应用入口
├── models.py            # SQLModel 模型定义
├── crud.py              # 数据访问层
├── utils.py             # 工具函数（邮件等）
├── core/
│   ├── config.py        # Pydantic Settings（环境变量）
│   ├── db.py            # 数据库引擎 + 会话管理
│   └── security.py      # JWT + 密码哈希
├── api/
│   ├── main.py          # APIRouter 组合
│   ├── deps.py          # FastAPI 依赖注入
│   └── routes/          # 按领域组织的路由模块
└── alembic/             # 数据库迁移
```

### 模型模式（SQLModel）

每个实体定义以下类型：
- `*Base`：共享字段
- `*Create` / `*Update` / `*Register`：输入 schema
- `*Public` / `*sPublic`：输出 schema
- `*`（带 `table=True`）：数据库模型

### 依赖注入

```python
# 常用依赖
SessionDep = Annotated[Session, Depends(get_db)]
CurrentUser = Annotated[User, Depends(get_current_user)]
```

### 添加新端点

1. 在 `app/models.py` 添加模型
2. 在 `app/crud.py` 添加数据访问函数
3. 在 `app/api/routes/` 添加路由
4. 在 `app/api/main.py` 注册路由
5. 运行数据库迁移

### 数据库迁移

```bash
cd backend
uv run alembic revision --autogenerate -m "描述"  # 创建迁移
uv run alembic upgrade head                        # 应用迁移
uv run alembic downgrade -1                        # 回滚一步
```

---

## 🎨 前端架构

### 目录结构

```
frontend/src/
├── routes/              # TanStack Router 文件路由
├── components/
│   ├── ui/              # shadcn/ui 组件（自动生成，勿手动修改）
│   ├── Admin/           # 管理面板组件
│   ├── UserSettings/    # 设置组件
│   ├── Common/          # 共享布局组件
│   └── Sidebar/         # 侧边栏
├── client/              # OpenAPI 自动生成的 API 客户端
├── hooks/               # 自定义 React Hooks
└── lib/                 # 工具函数
```

### API 客户端

- 使用 `@hey-api/openapi-ts` 自动生成
- 修改后端 API 后运行：`bash ./scripts/generate-client.sh`
- **不要手动编辑** `src/client/` 目录

---



