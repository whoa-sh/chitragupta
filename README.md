# Chitragupta

[![CI](https://github.com/whoash/chitragupta/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/whoash/chitragupta/actions/workflows/ci.yml)
[![Container Release](https://github.com/whoash/chitragupta/actions/workflows/container.yml/badge.svg?branch=master)](https://github.com/whoash/chitragupta/actions/workflows/container.yml)

`chitragupta` is a Kotlin + Spring Boot service using JPA, Flyway migrations, Actuator, and PostgreSQL.

Note: if this repository is private, badge URLs can return `404` for unauthenticated viewers.

## Stack

- Kotlin 2.2
- Java 21
- Spring Boot 4.0
- Spring Data JPA
- Flyway
- PostgreSQL
- Gradle wrapper
- Docker / Docker Compose

## Repository Layout

```text
.
|- src/main/kotlin/sh/whoa/chitragupta/
|- src/main/resources/
|  `- db/migration/
|- src/test/kotlin/sh/whoa/chitragupta/
|- Dockerfile
|- docker-compose.yml
|- docker-compose.dev.yml
|- .env.example
`- .github/workflows/
```

## Fast Start (Docker Only)

1. Clone the repo and `cd` into it.
2. Run: `docker compose up --build`
3. Open:
   - App: `http://localhost:8080`
   - Health: `http://localhost:8080/actuator/health`

This path is ready out-of-the-box with local-safe defaults.
If you want overrides, create `.env` from `.env.example`.

Stop:

- `docker compose down`
- `docker compose down -v` (also removes database volume)

## IDE Development (Dependencies Only)

Start only PostgreSQL:

```bash
docker compose -f docker-compose.dev.yml up -d
```

Run app from IDE with:

- `SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:${POSTGRES_PORT}/${POSTGRES_DB}`
- `SPRING_DATASOURCE_USERNAME=${POSTGRES_USER}`
- `SPRING_DATASOURCE_PASSWORD=${POSTGRES_PASSWORD}`

## Migrations (Flyway)

- Migrations live in `src/main/resources/db/migration`.
- Naming convention: `V<version>__<description>.sql` (example: `V2__add_accounts_table.sql`).
- On startup, Flyway runs before JPA initialization.
- Current baseline: `V1__init.sql`.

## CI/CD Policy

### CI (`.github/workflows/ci.yml`)

Runs on:

- Pull requests to `master`
- Pushes to `master`

Jobs run in parallel:

- `Lint (ktlint)` -> `ktlintCheck`
- `Build & Test (Gradle)` -> `clean test build`
- `Docker Smoke Test` -> cached image build, compose start, health wait, teardown

PR behavior:

- Checks only
- No image publishing

### Container Release (`.github/workflows/container.yml`)

Runs on:

- Push to `master`
- Manual `workflow_dispatch`

Flow:

1. Build local scan image
2. Generate SBOM (CycloneDX JSON)
3. Vulnerability scan gate (fail at `high` and above)
4. Publish to GHCR only after scan passes
5. Emit build provenance attestation

## Container Hardening

- Multi-stage Docker build
- Non-root runtime user
- Read-only root filesystem for app container
- `tmpfs` mount for `/tmp`
- `cap_drop: [ALL]`
- `no-new-privileges:true`
- Explicit CPU/memory/pid limits and memory reservations for app and PostgreSQL
- Healthchecks for app and database

## Environment Variables

Defined in `.env.example`:

- `APP_PORT`
- `SPRING_PROFILES_ACTIVE`
- `JAVA_OPTS`
- `APP_TMPFS_SIZE`
- `APP_PIDS_LIMIT`
- `APP_MEM_LIMIT`
- `APP_MEM_RESERVATION`
- `APP_CPUS_LIMIT`
- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `POSTGRES_PORT`
- `POSTGRES_PIDS_LIMIT`
- `POSTGRES_MEM_LIMIT`
- `POSTGRES_MEM_RESERVATION`
- `POSTGRES_CPUS_LIMIT`

## Build and Test Commands

- `./gradlew test`
- `./gradlew build`
- `./gradlew ktlintCheck`
- `./gradlew clean`

On Windows, use `.\gradlew.bat ...`.

## Production Notes

Before production:

1. Replace all local default credentials.
2. Restrict database port exposure.
3. Tune JVM and container limits for workload.
4. Pin base image digests and patch regularly.
5. Keep branch protection requiring CI checks on `master`.

## Branching Policy

- Do all new work on a feature branch, not `master`.
- Open pull requests into `master` after checks pass.
