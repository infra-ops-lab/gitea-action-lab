#!/usr/bin/env bash
# Mint a runner registration token from Gitea, store it as a k8s secret, deploy act_runner.
set -euo pipefail

: "${GITEA_URL:?set GITEA_URL, e.g. http://gitea.lab:30300}"
: "${GITEA_ADMIN_USER:?set GITEA_ADMIN_USER (a Gitea site admin)}"
: "${GITEA_ADMIN_PASS:?set GITEA_ADMIN_PASS}"
KUBECTL="${KUBECTL:-kubectl}"
here="$(cd "$(dirname "$0")" && pwd)"

token=$(curl -fsS -u "$GITEA_ADMIN_USER:$GITEA_ADMIN_PASS" -X POST \
  "$GITEA_URL/api/v1/admin/actions/runners/registration-token" \
  | python3 -c 'import json,sys; print(json.load(sys.stdin)["token"])')

$KUBECTL create namespace gitea-actions --dry-run=client -o yaml | $KUBECTL apply -f -
$KUBECTL -n gitea-actions create secret generic runner-token \
  --from-literal=token="$token" --dry-run=client -o yaml | $KUBECTL apply -f -
$KUBECTL apply -f "$here/act-runner.yaml"
$KUBECTL -n gitea-actions rollout status deploy/act-runner --timeout=300s
$KUBECTL -n gitea-actions logs deploy/act-runner -c runner --tail=5
