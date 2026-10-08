# Lab 0: Setup

## 1. Fork and open a Codespace

1. Fork this repository to your own GitHub account. The fork must be **public**: Argo CD reads it without credentials, and the workshop does not set any up.
2. In your fork, select **Code** > **Codespaces** > **Create codespace on main**.
3. Wait for the post-create script to finish. It installs `kind`, `kubectl`, the `argocd` CLI and `jq`.

Check the tools:

```bash
docker ps
kind version
kubectl version --client
argocd version --client --short
```

## 2. Point the GitOps manifests at your fork

The files in `gitops/` contain the placeholder `https://github.com/CHANGE_ME/argocd-dr-workshop.git`. Replace it with your fork's URL, then commit and push:

```bash
make configure
```

In Codespaces the script reads your fork's name from `GITHUB_REPOSITORY`. Elsewhere it uses `git remote get-url origin`.

> [!NOTE]
> You will not need these manifests until Lab 3. Doing this now means Lab 3 is not interrupted.

## 3. Get to know the make targets

```bash
make help
```

Next: [Lab 1: Life with ClickOps](01-clickops.md)
