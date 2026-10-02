# 02 — Multi-stage pipeline

**Goal:** chain jobs with `needs:`; a failing stage stops everything after it.

**Run:** copy `app.sh`, `test.sh`, `names.txt` to the repo root and `pipeline.yml` to
`.github/workflows/`. Then `chmod +x app.sh test.sh`, commit, push.
Locally first: `./test.sh` → `PASS`.

**Expect:** `pipeline` run → lint → test → package → deploy, all green.

**Break it**
- add a 4th name to `names.txt` → `test` red, `package` + `deploy` skipped
- fix: `-eq 3` → `-eq 4` in `test.sh` → green again

**Stop workflows you don't need** — every file with `on: push` runs on *every* push.

| How | Effect |
|---|---|
| Actions → pick the workflow → **⋯ → Disable workflow** | no runs until re-enabled; no git change |
| `on: [workflow_dispatch]` | only runs when you click **Run workflow** |
| `on: { push: { paths: ['app.sh', 'test.sh', 'names.txt'] } }` | runs only when those files change |
| `[skip ci]` in the commit message | nothing runs for that one push |
| open a running run → **Cancel** | stops it now |
