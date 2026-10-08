# Lab 3: Life with GitOps

The same setup again, but this time it is declared in Git. Take a few minutes to read `gitops/`:

| File | What it replaces from Lab 1 |
| --- | --- |
| `gitops/argocd/values.yaml` | The default Helm install. Argo CD's own settings are in Git too |
| `gitops/apps/guestbook.yaml` | Your **+ New App** form |
| `gitops/apps/helm-guestbook.yaml`, `kustomize-guestbook.yaml` | Your `argocd app create` commands |
| `gitops/apps/guestbook-envs-appset.yaml` | Nothing. ApplicationSets cannot be created in the UI |
| `gitops/bootstrap/root.yaml` | The single Application that creates all the others |

## 1. Bootstrap

```bash
make cluster NAME=primary
make bootstrap
```

`make bootstrap` runs two commands. Open `scripts/bootstrap.sh` to see them:

```bash
helm upgrade --install argocd argo-cd --repo https://argoproj.github.io/argo-helm \
  --version 10.10.1 --namespace argocd --create-namespace -f gitops/argocd/values.yaml
kubectl apply -f gitops/bootstrap/root.yaml
```

Open the UI and check that the banner and all the apps are there.

## 2. Change something through Git

Add a QA environment to the ApplicationSet. Edit `gitops/apps/guestbook-envs-appset.yaml`:

```yaml
        elements:
          - env: dev
          - env: qa
          - env: prod
```

Commit and push:

```bash
git commit -am "Add a QA environment for the guestbook"
git push
```

Within about a minute (`timeout.reconciliation` is set to `60s`), Argo CD creates a `guestbook-qa` app. To sync right away, select **Refresh** on the `root` app in the UI.

```bash
argocd app get guestbook-qa
git log --oneline -- gitops/apps/guestbook-envs-appset.yaml
```

The Git history now answers "who changed what, when and why."

## 3. Try ClickOps anyway

In the UI, open `guestbook`, select **Details**, and select **Disable Auto-Sync** under **Sync Policy**.

Watch what happens. Self-heal on the `root` app puts the Application back the way Git describes it. Git is the source of truth, so a change made only in the UI does not survive.

## 4. Add a new app through Git

Copy `gitops/apps/guestbook.yaml` to `gitops/apps/my-app.yaml`. Change `metadata.name` to `my-app` and `destination.namespace` to `my-app`. Commit and push, then watch the root app create it.

Next: [Lab 4: Disaster #2](04-gitops-disaster.md)
