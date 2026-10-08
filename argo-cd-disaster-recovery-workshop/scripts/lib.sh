#!/usr/bin/env bash
# Shared helpers for the workshop scripts.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${ROOT_DIR}/scripts/versions.env"

bold()  { printf '\033[1m%s\033[0m\n' "$*"; }
info()  { printf '\033[36m==>\033[0m %s\n' "$*"; }
ok()    { printf '\033[32m✔\033[0m %s\n' "$*"; }
warn()  { printf '\033[33m!\033[0m %s\n' "$*"; }
fail()  { printf '\033[31m✘\033[0m %s\n' "$*" >&2; exit 1; }

require_cluster() {
  kubectl cluster-info >/dev/null 2>&1 || fail "No reachable cluster. Run 'make cluster NAME=<name>' first."
}

wait_for_argocd() {
  info "Waiting for Argo CD components to become ready"
  kubectl -n argocd rollout status deploy/argocd-server --timeout=300s
  kubectl -n argocd rollout status deploy/argocd-repo-server --timeout=300s
  kubectl -n argocd rollout status statefulset/argocd-application-controller --timeout=300s
  kubectl -n argocd rollout status deploy/argocd-applicationset-controller --timeout=300s
}

wait_for_ui() {
  info "Waiting for the Argo CD UI on http://localhost:8080"
  for _ in $(seq 1 60); do
    curl -fsS -o /dev/null http://localhost:8080/healthz 2>/dev/null && return 0
    sleep 2
  done
  fail "The Argo CD UI is not reachable on localhost:8080. Was the cluster created with 'make cluster'?"
}

admin_password() {
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
}

cli_login() {
  local pass
  pass="$(admin_password)"
  # --grpc-web sends the CLI's gRPC calls as plain HTTP/1.1 requests, which work through any proxy.
  argocd login localhost:8080 --plaintext --grpc-web --username admin --password "${pass}" >/dev/null
  ok "argocd CLI logged in as admin"
  echo
  bold "Argo CD UI: http://localhost:8080 (in Codespaces: PORTS tab, port 8080)"
  bold "Username:   admin"
  bold "Password:   ${pass}"
}


# helm_install_argocd installs (or upgrades) the Argo CD Helm chart.
# Extra arguments are passed to helm, e.g. -f values.yaml.
helm_install_argocd() {
  helm upgrade --install argocd argo-cd \
    --repo https://argoproj.github.io/argo-helm \
    --version "${ARGOCD_CHART_VERSION}" \
    --namespace argocd --create-namespace \
    "$@" >/dev/null
}
