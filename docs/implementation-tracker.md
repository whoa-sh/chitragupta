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
| T1 | Create implementation tracker | done | Tracker exists with tasks, decisions, and evidence fields | `docker compose up --build -d` and `docker compose ps` showed `app` + `postgres` healthy | pending | Host Java 21 toolchain unavailable; using containerized runnable gate |
| T2 | Add ktlint plugin and lint task | todo | `ktlintCheck` runs locally and in CI | Build + boot + compose healthcheck pass after change | pending | Parallel CI lint job |
| T3 | Introduce Flyway migrations | todo | Flyway configured, `V1__init.sql` present, app starts with migrations | Build + boot + compose healthcheck pass after change | pending | Baseline migration added |
| T4 | Harden Docker and Compose runtime | todo | Non-root + locked-down container options without startup regression | `docker compose up --build` healthy | pending | Security hardening |
| T5 | Add CI sanity workflow | todo | PR and master checks run; lint/build in parallel; no publish in PR | Workflow validates and local checks pass | pending | `.github/workflows/ci.yml` |
| T6 | Add container release workflow | todo | Master-only publish path + SBOM + vulnerability scan | Workflow validates and local checks pass | pending | `.github/workflows/container.yml` |
| T7 | Add Dependabot config | todo | Actions/Gradle/Docker updates configured | N/A | pending | `.github/dependabot.yml` |
| T8 | Add CI badges + docs updates | todo | README badges and policy docs are complete | Build + boot + compose healthcheck pass after change | pending | Final doc pass |

## Validation Commands

- Build: `./gradlew.bat clean build`
- Unit tests: `./gradlew.bat test`
- Run from Gradle (DB-backed): `./gradlew.bat bootRun`
- Compose validation: `docker compose config`
- Compose run/health: `docker compose up --build -d` and `GET /actuator/health`
