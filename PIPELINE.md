1. Which events trigger CI, and why?
push to main (ignoring *.md and docs/**): verify every change that lands on the main branch; docs-only changes cannot break code, so we save runner minutes.
pull_request to main: catch problems before merging.
workflow_dispatch (inputs: python-version, create-package): run on demand for a chosen Python version, with or without packaging.
schedule (Mondays 07:00 UTC): detect "bit rot" (new pytest / Python releases, dependency changes) even when nobody pushes code.
