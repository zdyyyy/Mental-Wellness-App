# MindLift API (Ruby on Rails)

Rails 7 API 后端，替代原 `backend/` Spring Boot 实现。与 `frontend/` React 应用使用相同的 REST 契约（camelCase JSON、JWT、端口 3000）。

## 环境要求

- Ruby 3.2+
- Bundler 2+
- （可选）Docker：RabbitMQ

## 快速开始

```bash
cd rails
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

API：`http://localhost:3000`

演示账号：`demo` / `demo123`

## RabbitMQ（可选）

```bash
docker compose up -d
bin/rails rabbitmq:setup
bin/rails rabbitmq:listen   # 单独终端，消费情绪同步消息
```

关闭 RabbitMQ 时设置 `MINDLIFT_RABBITMQ_ENABLED=false`，情绪将同步写入用户表（与 Spring 版行为一致）。

## 环境变量

| 变量 | 说明 |
|------|------|
| `OPENAI_API_KEY` | OpenAI（情绪分析、聊天、预测） |
| `MINDLIFT_JWT_SECRET` | JWT 密钥（生产环境至少 32 字符） |
| `MINDLIFT_RABBITMQ_ENABLED` | `true` / `false`（默认 true） |
| `RABBITMQ_URL` | 默认 `amqp://guest:guest@localhost:5672` |

## 启动前端

```bash
cd frontend
npm install
npm run dev
```

Vite 已将 `/api` 代理到 `http://localhost:3000`。

## 项目结构

```
app/
  controllers/api/   REST 控制器
  models/            ActiveRecord 模型
  services/          业务逻辑（Auth、Mood、Chat、OpenAI 等）
config/
  routes.rb
  mindlift.yml       应用配置
db/
  migrate/
  seeds.rb
```

原 Java 后端保留在 `backend/`，Android 客户端仍在 `app/`。
