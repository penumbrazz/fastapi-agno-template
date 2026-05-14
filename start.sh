#!/usr/bin/env bash
set -e

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$PROJECT_ROOT/backend"
FRONTEND_DIR="$PROJECT_ROOT/frontend"

echo "==> [1/6] 安装后端依赖..."
cd "$BACKEND_DIR"
uv venv
uv pip install -e ".[dev]" 2>/dev/null || uv pip install -e .

echo "==> [2/6] 初始化数据库（迁移 + 种子数据）..."
cd "$BACKEND_DIR"
uv run python app/backend_pre_start.py
uv run alembic upgrade head
uv run python app/initial_data.py

echo "==> [3/6] 启动后端服务 (port 8001)..."
cd "$BACKEND_DIR"
uv run fastapi run --port 8001 --reload app/main.py &
BACKEND_PID=$!
echo "    后端 PID: $BACKEND_PID"

echo "==> [4/6] 安装前端依赖..."
cd "$FRONTEND_DIR"
bun install

echo "==> [5/6] 启动前端开发服务器..."
cd "$FRONTEND_DIR"
bun run dev &
FRONTEND_PID=$!
echo "    前端 PID: $FRONTEND_PID"

echo ""
echo "==> [6/6] 全部启动完成！"
echo "    后端 API:    http://localhost:8001"
echo "    后端文档:    http://localhost:8001/docs"
echo "    前端界面:    http://localhost:5173"
echo ""
echo "按 Ctrl+C 停止所有服务"

cleanup() {
    echo ""
    echo "正在停止服务..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    wait $BACKEND_PID $FRONTEND_PID 2>/dev/null
    echo "已停止。"
}
trap cleanup EXIT INT TERM

wait
