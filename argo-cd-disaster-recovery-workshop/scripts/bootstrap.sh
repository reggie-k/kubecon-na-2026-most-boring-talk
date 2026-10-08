#!/usr/bin/env bash
# The whole disaster recovery runbook for the GitOps setup:
#   1. install Argo CD with Helm, using the values in Git
#   2. apply the root Application (from Git)
# Everything else is pulled from Git by Argo CD.
source "$(dirname "$0")/lib.sh"
require_cluster
cd "${ROOT_DIR}"

if grep -rq "CHANGE_ME" gitops; then
  fail "The GitOps manifests still point at CHANGE_ME. Run 'make configure' first."
fi

start=$(date +%s)

bold "Step 1/2: install Argo CD with Helm, using gitops/argocd/values.yaml"
helm_install_argocd -f gitops/argocd/values.yaml
wait_for_argocd

bold "Step 2/2: apply the root Application"
kubectl apply -f gitops/bootstrap/root.yaml

info "Waiting for Argo CD to recreate everything from Git"
deadline=$(( $(date +%s) + 600 ))
while :; do
  apps="$(kubectl -n argocd get applications.argoproj.io -o json)"
  count="$(jq '.items | length' <<<"${apps}")"
  pending="$(jq '[.items[] | select(.status.sync.status != "Synced" or .status.health.status != "Healthy")] | length' <<<"${apps}")"
  printf '\r  %s applications, %s still syncing   ' "${count}" "${pending}"
  if (( count > 1 && pending == 0 )); then echo; break; fi
  if (( $(date +%s) > deadline )); then echo; warn "Some applications are not healthy yet. Check the UI."; break; fi
  sleep 5
done

kubectl -n argocd get applications.argoproj.io
echo
ok "Recovered in $(( $(date +%s) - start )) seconds"
echo
wait_for_ui
cli_login
