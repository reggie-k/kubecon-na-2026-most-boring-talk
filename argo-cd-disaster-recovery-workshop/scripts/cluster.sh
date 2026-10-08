#!/usr/bin/env bash
# Creates a fresh kind cluster and switches kubectl to it.
source "$(dirname "$0")/lib.sh"

NAME="${1:?usage: cluster.sh <name>}"

if kind get clusters 2>/dev/null | grep -qx "${NAME}"; then
  warn "Cluster '${NAME}' already exists, reusing it"
else
  info "Creating kind cluster '${NAME}'"
  kind create cluster --name "${NAME}" --wait 120s
fi
kubectl config use-context "kind-${NAME}" >/dev/null
ok "kubectl now points at kind-${NAME}"
