# 04 — Secrets + SSH to a remote host

**Goal:** run `hostname`, `ls -ltr`, `df -h` on a remote Linux host without credentials in
the repo.

**Run**
1. Add secrets — Gitea: Settings → **Actions ›** (expand) → Secrets · GitHub: Settings →
   Secrets and variables → Actions
   - `SSH_USER` = login user · `SSH_PASS` = its password
2. Copy `remote-ssh.yml` to `.github/workflows/`, set `HOST` to your server
   (`203.0.113.10` is a placeholder), push → Actions → `remote-ssh` → **Run workflow**.

**Expect:** the log shows the remote hostname and disk usage; the password appears as `***`.

**Rules**
- secrets → `env:` → `sshpass -e` (never `-p <password>`)
- the *runner* must reach the host — cloud runners can't see private IPs
- never `StrictHostKeyChecking=no`; for real use store the host key as a secret
- better than a password: a per-pipeline SSH key, pinned with `command="…"` in `authorized_keys`
