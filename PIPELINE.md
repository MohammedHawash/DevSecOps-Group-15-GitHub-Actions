# Pipeline Design

## 1. Which events trigger CI, and why?
- **push to `main`** (ignoring `*.md` and `docs/**`): verify every change that lands on the main branch; docs-only changes cannot break code, so we save runner minutes.
- **pull_request to `main`**: catch problems *before* merging.
- **workflow_dispatch** (inputs: `python-version`, `create-package`): run on demand for a chosen Python version, with or without packaging.
- **schedule** (Mondays 07:00 UTC): detect "bit rot" (new pytest / Python releases, dependency changes) even when nobody pushes code.

## 2. Jobs and job graph

```
test ──► package ──► verify ──► pr-comment (PRs only)
  │         │
  └────┬────┘
       ▼
     report   (always runs)
```
- `test` runs first, alone.
- `package` waits for `test`.
- `verify` waits for `package`.
- `pr-comment` waits for `package` and `verify` and runs only on pull requests.
- `report` waits for `test` and `package` but uses `if: always()`, so it runs whatever happened.

## 3. The artifact
A versioned source package `dist/temperature-0.1.<run_number>.tar.gz` (containing `temperature.py` and `README.md`), uploaded as artifact `package`. A secondary artifact `test-report` holds the JUnit XML.

## 4. CI, Continuous Delivery or Continuous Deployment?
It is **Continuous Integration**: it builds, tests and verifies every change, but it never releases or deploys the package anywhere.

## 5. What happens to `package` when tests fail?
It is **skipped**, because `package` depends on `test` and GitHub skips dependent jobs when a needed job fails. That is what we want: we must never produce a deliverable from code that did not pass its tests, and it saves runner time.