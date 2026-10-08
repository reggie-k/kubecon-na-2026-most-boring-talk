#!/usr/bin/env bash
# Shows which cluster you are on and what Argo CD manages there.
source "$(dirname "$0")/lib.sh"
echo "kind clusters: $(kind get clusters 2>/dev/null | xargs echo)"
echo "current context: $(kubectl config current-context 2>/dev/null || echo none)"
require_cluster
echo
kubectl -n argocd get appprojects.argoproj.io,applicationsets.argoproj.io,applications.argoproj.io 2>/dev/null \
  || warn "Argo CD is not installed on this cluster"
