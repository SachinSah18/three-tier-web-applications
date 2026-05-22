# Project Run Commands

Is project ko ab Next.js se hataakar normal Node.js 3-tier structure me split kiya gaya hai.

## Folder Meaning

- `frontend/` - React + Vite frontend
- `backend/` - Node.js + Express API
- `database/` - MySQL database SQL file
- `nginx/` - Nginx reverse proxy config

## Docker Se Run Karna

Sabse easy command:

```bash
docker compose up --build
```

Browser me open karein:

```text
http://localhost
```

Stop karne ke liye:

```bash
docker compose down
```

Database volume bhi delete karke fresh start chahiye ho:

```bash
docker compose down -v
docker compose up --build
```

## Local Machine Par Run Karna

Dependencies install:

```bash
npm install
```

MySQL locally start karke database create karein:

```bash
mysql -u root -p < database/init.sql
```

Backend run:

```bash
npm run dev --workspace backend
```

Frontend run dusre terminal me:

```bash
npm run dev --workspace frontend
```

Open:

```text
http://localhost:5173
```

## Useful Commands

Build frontend:

```bash
npm run build
```

TypeScript check:

```bash
npm run typecheck
```

Lint:

```bash
npm run lint
```

Backend production start:

```bash
npm run start --workspace backend
```

## Environment Variables

Backend defaults ye hain:

```text
PORT=3000
DB_HOST=localhost
DB_PORT=3306
DB_USER=employee_user
DB_PASSWORD=employee_password
DB_NAME=employee_db
```

Frontend local development me `/api` requests Vite proxy ke through `http://localhost:3000` backend par jaati hain.
