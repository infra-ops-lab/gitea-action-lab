# 00 — Runner setup

**Goal:** Gitea only schedules jobs; `act_runner` executes them. Install it on k8s.

**Run**
```bash
# 1. Gitea must know its real address (checkout clones from it) and must not RollingUpdate
helm upgrade gitea gitea-charts/gitea -n gitea --reuse-values \
  --set strategy.type=Recreate --set gitea.config.server.ROOT_URL=http://<gitea-host>:<port>/

# 2. Register + deploy the runner (needs a Gitea site-admin login)
export GITEA_URL=http://<gitea-host>:<port> GITEA_ADMIN_USER=<admin>
read -rsp "password: " GITEA_ADMIN_PASS; export GITEA_ADMIN_PASS
./register-runner.sh          # k3s: KUBECTL="sudo k3s kubectl" ./register-runner.sh
```

**Expect:** `kubectl -n gitea-actions get pods` → `act-runner-…  2/2 Running`;
Gitea → Site Administration → Actions → Runners → `k8s-runner-1` Idle.

**Gotchas:** `ROOT_URL` left default → every job fails at checkout · RollingUpdate with
SQLite on one RWO volume → new pod can't lock the DB (`Recreate` fixes it) · helm on k3s
needs `--kubeconfig /etc/rancher/k3s/k3s.yaml` · dind is privileged — lab only.

**Files:** `act-runner.yaml` (namespace, PVC, runner + dind) · `register-runner.sh`
