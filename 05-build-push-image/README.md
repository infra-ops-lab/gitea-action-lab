# 05 — Build + push a container image

**Goal:** every push builds and tests an image; only `main` pushes it to Gitea's built-in
registry, tagged with the short commit SHA. That tag is what a GitOps tool deploys next.

**Prerequisites:** the runner from [00-setup](../00-setup/) shares dind's Docker socket
(act_runner mounts it into each job container) and dind trusts the HTTP registry
(`--insecure-registry`).

**Run**
1. Gitea → your avatar → Settings → Applications → **Generate New Token**, name `ci-registry`,
   permission **package: Read and Write** → copy it (shown only once).
2. Repo → Settings → **Actions ›** (expand) → Secrets → **Add Secret**, twice:

   | Name (exact) | Value |
   |---|---|
   | `REGISTRY_USER` | your Gitea username |
   | `REGISTRY_TOKEN` | the token from step 1 — not your password |

   The workflow reads them as `${{ secrets.REGISTRY_USER }}` / `${{ secrets.REGISTRY_TOKEN }}`
   → `docker login`; the token shows as `***` in logs.
3. Copy `web/` to the repo root and `image.yml` to `.github/workflows/`; set `IMAGE` /
   `REGISTRY` to your Gitea host and owner. Push.

**Expect:** `image` run green → build · test `PASS` · push.

**See the image** — packages belong to the **user/org**, not the repo:
- `http://<gitea-host>:<port>/<owner>/-/packages` (avatar → Your Profile → **Packages**)
- open `hello-web` → tags `<sha7>` + `latest`, size, ready-made `docker pull` command
- repo's own Packages tab stays empty until you link it: package → **Settings** →
  **Link to repository**
- empty list? the **push** step was skipped (not `main`) or the run failed

**Break it**
- push from a branch → build + test run, **push is skipped** (`if: github.ref_name == 'main'`)
- change the `<h1>` text → `test` red, nothing is pushed
- remove `--insecure-registry` from dind → push fails `http: server gave HTTP response to HTTPS client`
