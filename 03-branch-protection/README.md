# 03 — Branch protection

**Goal:** no direct pushes to `main`; a PR needs green CI, an approval, and an issue key in
its title.

**Run**
1. Copy `pr-check.yml` to `.github/workflows/`, push.
2. Protect `main`:
   - Gitea: Settings → Branches → Add rule → disable push · required approvals `1` ·
     status checks `lint`, `jira-id`
   - GitHub: `gh api -X PUT repos/<owner>/<repo>/branches/main/protection --input protection.json`
     (working alone? keep approvals `0` — you can't approve your own PR)

**Expect / break it**
- `git push origin main` → rejected
- PR titled `fix stuff` → `jira-id` red, merge disabled
- rename to `ABC-1 fix stuff` → green → approve → merge
