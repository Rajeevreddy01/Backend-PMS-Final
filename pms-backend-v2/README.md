# PMS Backend — Render Deployment Guide

## Stack
- Java 17 · Spring Boot 3.2 · PostgreSQL · Docker

## Deploy to Render (Blueprint)

1. Push this folder to a GitHub repository.
2. Go to **Render Dashboard → New → Blueprint**.
3. Connect your GitHub repo — Render will detect `render.yaml` automatically.
4. Click **Apply** — Render creates:
   - A **Web Service** (`pms-backend`) running the Docker container
   - A **PostgreSQL database** (`pms-postgres`) linked automatically
5. After deploy, copy the backend URL (e.g. `https://pms-backend.onrender.com`).
6. Update the `FRONTEND_URL` environment variable in the Render dashboard to your frontend URL.

## Deploy to Render (Manual)

1. **Create PostgreSQL database**
   - New → PostgreSQL → Name: `pms-postgres` → Plan: Free → Create
   - Note the **Internal Database URL** and individual credentials.

2. **Create Web Service**
   - New → Web Service → Connect GitHub repo
   - Environment: **Docker**
   - Add environment variables:
     | Key | Value |
     |-----|-------|
     | `PGHOST` | *(from DB dashboard)* |
     | `PGPORT` | `5432` |
     | `PGDATABASE` | `pms_db` |
     | `PGUSER` | `pms_user` |
     | `PGPASSWORD` | *(from DB dashboard)* |
     | `JWT_SECRET` | *(any long random string)* |
     | `FRONTEND_URL` | `https://your-frontend.onrender.com` |

3. Deploy → wait for build (~3–5 min on free tier).

## Local Development

```bash
# Start a local PostgreSQL instance (Docker)
docker run -d \
  --name pms-postgres \
  -e POSTGRES_DB=pms_db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  postgres:15-alpine

# Run the app
./mvnw spring-boot:run
```

Or set environment variables to point to any existing PostgreSQL instance:
```bash
export PGHOST=localhost
export PGPORT=5432
export PGDATABASE=pms_db
export PGUSER=postgres
export PGPASSWORD=postgres
./mvnw spring-boot:run
```

## Default Seed Users

| Username | Password | Role |
|----------|----------|------|
| admin | admin123 | ADMIN |
| manager1 | admin123 | MANAGER |
| dev1 | admin123 | USER |
