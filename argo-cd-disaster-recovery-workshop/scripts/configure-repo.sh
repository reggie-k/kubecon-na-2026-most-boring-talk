#!/usr/bin/env bash
# Points every Argo CD Application in gitops/ at YOUR fork of this repository,
# then commits and pushes so Argo CD can read it.
source "$(dirname "$0")/lib.sh"
cd "${ROOT_DIR}"

PLACEHOLDER="https://github.com/CHANGE_ME/argocd-dr-workshop.git"

URL="${1:-}"
if [[ -z "${URL}" && -n "${GITHUB_REPOSITORY:-}" ]]; then
  URL="https://github.com/${GITHUB_REPOSITORY}.git"   # set automatically in Codespaces
fi
if [[ -z "${URL}" ]]; then
  URL="$(git remote get-url origin | sed -E 's#^git@github.com:#https://github.com/#')"
fi
[[ "${URL}" == *.git ]] || URL="${URL}.git"

files="$(grep -rl "${PLACEHOLDER}" gitops || true)"
if [[ -z "${files}" ]]; then
  ok "Already configured: $(grep -h 'repoURL:' gitops/bootstrap/root.yaml | awk '{print $2}')"
  exit 0
fi

# Argo CD paths are relative to the repository root. If the workshop lives in a
# subfolder of the repository, prefix the paths of our own manifests with it.
PREFIX="$(git rev-parse --show-prefix)"

info "Pointing the GitOps manifests at ${URL}${PREFIX:+ (folder ${PREFIX})}"
for f in ${files}; do
  perl -pi -e "s#\Q${PLACEHOLDER}\E#${URL}#g; s#^(\s*path:\s*)gitops/#\${1}${PREFIX}gitops/#" "${f}"
  echo "  updated ${f}"
done

git add gitops
git commit -m "Point the workshop GitOps manifests at ${URL}"
git push
ok "Pushed. Argo CD will read its desired state from ${URL}"
