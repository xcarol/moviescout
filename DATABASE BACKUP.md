# Supabase Database Backup (Docker-less / Native pg_dump)

This guide documents how to create a manual backup of the remote Supabase PostgreSQL database without depending on Docker Desktop or the Supabase CLI dump command.

---

## 1. Prerequisites

Ensure the native PostgreSQL client tools are installed on your system:

```bash
# Verify if pg_dump is available
pg_dump --version

# If not installed, install the client package (Ubuntu/Debian)
sudo apt update && sudo apt install -y postgresql-client
```

---

## 2. Connection Configuration & Credentials

### A. Project ID and Region

- You can locate them in: `Project Settings` > `General settings`.

### B. Database Password

- Supabase requires the dedicated database password (for the `postgres` role).
- Note: This is **not** your GitHub login password and **not** an API key (`anon` / `service_role`).
- If you don't know it, you can reset it by navigating to:
  `Database` > _Configuration_ `Settings` > `Database password` > `Reset database password`.
- Direct link format:
  `https://supabase.com/dashboard/project/<PROJECT_ID>/database/settings#database-password`

---

## 3. Creating the Backup

Replace `[PROJECT-ID]`, `[REGION]`, and `[PASSWORD]` with your project details:

### Full Backup (Schema & Data)

```bash
pg_dump "postgresql://postgres.[PROJECT-ID]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:5432/postgres" -f backup.sql
```

### Schema Only (DDL / Tables / Functions / Policies)

```bash
pg_dump --schema-only "postgresql://postgres.[PROJECT-ID]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:5432/postgres" -f schema.sql
```

### Data Only

```bash
pg_dump --data-only --inserts "postgresql://postgres.[PROJECT-ID]:[PASSWORD]@aws-0-[REGION].pooler.supabase.com:5432/postgres" -f data.sql
```

---

## 4. Verification

Verify that the backup was generated successfully and contains valid SQL statements:

```bash
ls -lh backup.sql
head -n 25 backup.sql
```
