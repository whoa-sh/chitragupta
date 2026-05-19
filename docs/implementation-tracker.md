# Enterprise Rollout Implementation Tracker

Last updated: 2026-05-19

## Decision Log

- Default branch: `master`
- Pull request policy: run checks, never publish/push container images
- Workflow actions: use latest stable major versions at implementation time
- Secrets management: out of scope for this rollout
- Execution policy: app must remain buildable and runnable at every subsystem stage

## Task Tracker

| ID | Task | Status | Acceptance Criteria | Runnable Gate Evidence | Commit SHA | Notes |
|---|---|---|---|---|---|---|
| T1 | Create implementation tracker | done | Tracker exists with tasks, decisions, and evidence fields | `docker compose up --build -d` and `docker compose ps` showed `app` + `postgres` healthy | 622ff76 | Host Java 21 toolchain unavailable; using containerized runnable gate |
| T2 | Add ktlint plugin and lint task | done | `ktlintCheck` runs locally and in CI | `docker run ... ./gradlew --no-daemon ktlintCheck` succeeded; compose app remained healthy | 8b93077 | Parallel CI lint job |
| T3 | Introduce Flyway migrations | done | Flyway configured, `V1__init.sql` present, app starts with migrations | `docker compose` app healthy; logs show Flyway migrate v1; Postgres has `flyway_schema_history` + `app_schema_marker` | d727e32 | Added `flyway-database-postgresql` for PostgreSQL 17.5 compatibility |
| T4 | Harden Docker and Compose runtime | done | Non-root + locked-down container options without startup regression | `docker compose config` valid, `docker compose up --build -d` and `docker compose ps` showed healthy app + DB | ce6218d | Added read-only FS, tmpfs, dropped caps, and no-new-privileges |
| T5 | Add CI sanity workflow | done | PR and master checks run; lint/build in parallel; no publish in PR | `actionlint` clean for workflow files; compose app remained healthy | 56ce26f | `.github/workflows/ci.yml` |
| T6 | Add container release workflow | done | Master-only publish path + SBOM + vulnerability scan | `actionlint` clean for workflow files; publish guarded to `refs/heads/master` push only | pending | `.github/workflows/container.yml` |
| T7 | Add Dependabot config | done | Actions/Gradle/Docker updates configured | Config created under `.github/dependabot.yml` | pending | Weekly updates for actions, gradle, and docker |
| T8 | Add CI badges + docs updates | todo | README badges and policy docs are complete | Build + boot + compose healthcheck pass after change | pending | Final doc pass |

## Validation Commands

- Build: `./gradlew.bat clean build`
- Unit tests: `./gradlew.bat test`
- Run from Gradle (DB-backed): `./gradlew.bat bootRun`
- Compose validation: `docker compose config`
- Compose run/health: `docker compose up --build -d` and `GET /actuator/health`
