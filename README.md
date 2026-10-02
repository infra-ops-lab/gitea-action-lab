# gitea-actions-lab

> **Series** (do in order): 1. [gitea-actions-lab](https://github.com/infra-ops-lab/gitea-action-lab) — CI: build + push an image → 2. [argocd-gitops-lab](https://github.com/infra-ops-lab/argocd-gitops-lab) — CD: deploy it with GitOps → 3. jenkins-ci-lab (soon) → 4. cicd-capstone (soon): push code → new version live, no human step

Hands-on, code-first lab: GitHub-Actions-compatible CI on your own Kubernetes with Gitea Actions.
Each folder is one lesson — a short README (goal → run → expect → break it) and the code.

| # | Lesson | You get |
|---|---|---|
| 00 | [setup](00-setup/) | `act_runner` + Docker-in-Docker on k8s, registered to Gitea |
| 01 | [first-workflow](01-first-workflow/) | a workflow that runs on every push |
| 02 | [multi-stage-pipeline](02-multi-stage-pipeline/) | lint → test → package → deploy with `needs:` |
| 03 | [branch-protection](03-branch-protection/) | PR + approval + green CI + issue key required |
| 04 | [secrets-ssh](04-secrets-ssh/) | run commands on a remote host, credentials as secrets |
| 05 | [build-push-image](05-build-push-image/) | image built, tested, pushed to the registry, tagged by commit |

```
git push ─► Gitea (queues jobs) ◄─ poll ─ act_runner ─► dind ─► job container (your steps)
```

**Prerequisites:** a k8s cluster (single-node k3s is enough) and Gitea installed with its Helm
chart. Workflows go in `.github/workflows/` of a practice repo — the same files run on GitHub.
