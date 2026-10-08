#!/usr/bin/env bash
# Deletes all workshop clusters so you can start over.
source "$(dirname "$0")/lib.sh"
stop_port_forward
for c in $(kind get clusters 2>/dev/null); do kind delete cluster --name "${c}"; done
ok "Clean slate"
