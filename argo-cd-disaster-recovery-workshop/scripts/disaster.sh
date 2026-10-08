#!/usr/bin/env bash
# Destroys a cluster, and with it Argo CD and everything it knew about.
source "$(dirname "$0")/lib.sh"

NAME="${1:?usage: disaster.sh <name>}"
kind get clusters 2>/dev/null | grep -qx "${NAME}" || fail "No such cluster: ${NAME}"

stop_port_forward
echo
bold "🔥🔥🔥  The data center hosting '${NAME}' just caught fire  🔥🔥🔥"
kind delete cluster --name "${NAME}"
echo
warn "Cluster '${NAME}' is gone. So is Argo CD, and every Application it knew about."
