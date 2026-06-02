# MindLift

MindLift is a wellness web application for journaling, mood tracking, music therapy, and AI companion chat. It is a React + Ruby on Rails rewrite of the original Android **YogoPoseDetection** project. The web version focuses on mental wellness features and does not include yoga pose detection.

## Features

- **Authentication** — Sign up and sign in with JWT
- **Journaling** — Text or voice input with mood analysis (OpenAI optional; rule-based fallback without a key)
- **Music** — Browse genres, play songs, and get recommendations based on current mood
- **Mood insights** — View mood history, statistics, and next-day mood predictions
- **AI companion** — Supportive chat powered by OpenAI (simple fallback replies without a key)
- **RabbitMQ** (optional) — Async mood events after diary or chat updates, consumed to sync the user's current mood

The home screen uses a **2×2** layout: Music, Diary, Chat, and Mood Insights.

## Tech stack

| Layer    | Stack                                      |
| -------- | ------------------------------------------ |
| Frontend | React 18, TypeScript, Vite, React Router   |
| Backend  | Ruby on Rails 7 API, SQLite, JWT, bcrypt   |
| Messaging| RabbitMQ (optional, via Docker)            |
| AI       | OpenAI API (optional)                      |

## Project structure

```
backend/     Rails 7 JSON API
frontend/    React SPA
app/         Original Android client (legacy)
```

## Prerequisites

- Ruby 3.2+ and Bundler
- Node.js 18+
- Docker (optional, for RabbitMQ)

## Quick start

### Backend

```bash
cd backend
bundle install
bundle exec rails db:prepare
bundle exec rails db:seed
bundle exec rails server
```

API: `http://localhost:3000`

### Frontend

```bash
cd frontend
npm install
npm run dev
```

App: `http://localhost:5173`

In development, Vite proxies `/api` requests to port 3000.

### Demo account

After running `db:seed`:

| Field    | Value     |
| -------- | --------- |
| Username | `demo`    |
| Password | `demo123` |

Seed data includes four music genres and sample tracks (SoundHelix MP3 URLs).

## Environment variables

Optional settings for the backend:

| Variable                   | Description                                      |
| -------------------------- | ------------------------------------------------ |
| `OPENAI_API_KEY`           | OpenAI for mood analysis, chat, and predictions  |
| `MINDLIFT_JWT_SECRET`      | JWT secret (use at least 32 characters in prod)  |
| `MINDLIFT_RABBITMQ_ENABLED`| `true` or `false` (default `false` in development) |
| `RABBITMQ_URL`             | Default `amqp://guest:guest@localhost:5672`      |

Example (PowerShell):

```powershell
$env:OPENAI_API_KEY="sk-..."
$env:MINDLIFT_JWT_SECRET="your-production-secret-at-least-32-chars"
```

## RabbitMQ (optional)

```bash
cd backend
docker compose up -d
bundle exec rails rabbitmq:setup
```

In a separate terminal, run the consumer:

```bash
bundle exec rails rabbitmq:listen
```

Management UI: http://localhost:15672 (`guest` / `guest`)

To skip RabbitMQ, set `MINDLIFT_RABBITMQ_ENABLED=false`. Mood updates are written synchronously to the user record instead.

## API overview

| Method | Path                              | Description                    |
| ------ | --------------------------------- | ------------------------------ |
| POST   | `/api/auth/signup`                | Register                       |
| POST   | `/api/auth/login`                 | Log in                         |
| GET    | `/api/auth/me`                    | Current user (Bearer token)    |
| POST   | `/api/diary`                      | Append diary `{ "text": "..." }` |
| GET    | `/api/diary?date=YYYY-MM-DD`      | Diary for a date               |
| GET    | `/api/music/genres`               | List genres                    |
| GET    | `/api/music/recommendations`      | Mood-based genre recommendations |
| GET    | `/api/music/genres/:id/songs`     | Songs in a genre               |
| GET    | `/api/mood/trend?days=30`         | Mood history and counts        |
| GET    | `/api/mood/predict`               | Predict tomorrow's mood        |
| GET    | `/api/chat/history`               | Chat history                   |
| POST   | `/api/chat`                       | Send message `{ "message": "..." }` |

Responses use camelCase JSON for compatibility with the React client.

## Where to look in the codebase

1. `backend/app/controllers/api/` — REST endpoints
2. `frontend/src/api/client.ts` — Frontend API client
3. `frontend/src/pages/` — UI pages
4. `backend/app/services/` — Business logic and external integrations

## License

See repository history and contributors for licensing details.
