#!/usr/bin/env bash
# Creates a fresh kind cluster and switches kubectl to it.
source "$(dirname "$0")/lib.sh"

NAME="${1:?usage: cluster.sh <name>}"
existing="$(kind get clusters 2>/dev/null || true)"

if grep -qx "${NAME}" <<<"${existing}"; then
  warn "Cluster '${NAME}' already exists, reusing it"
else
  # Every cluster maps port 8080 for the Argo CD UI, so only one can run at a time.
  [[ -z "${existing}" ]] || fail "Cluster '${existing//$'\n'/, }' is still running. Run 'make disaster NAME=${existing%%$'\n'*}' first."
  info "Creating kind cluster '${NAME}'"
  kind create cluster --name "${NAME}" --config "${ROOT_DIR}/scripts/kind-config.yaml" --wait 120s
fi
kubectl config use-context "kind-${NAME}" >/dev/null
ok "kubectl now points at kind-${NAME}"
