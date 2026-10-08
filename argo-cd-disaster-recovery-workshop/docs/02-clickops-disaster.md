# Lab 2: Disaster #1

## 1. Lose the cluster

```bash
make disaster NAME=primary
```

The cluster is gone, along with Argo CD and every Application, project and setting in it.

## 2. Rebuild

Create a new cluster and a fresh Argo CD:

```bash
make cluster NAME=dr
make install-argocd
```

Notice that the admin password has changed.

Now create your three apps again, using the UI or the CLI. You have **10 minutes**. Don't scroll back through your terminal history or Lab 1, because in a real disaster that history lived on someone else's laptop.

When time is up, check your work against the list below.

<details>
<summary>Everything that existed before the disaster</summary>

| Object | Details |
| --- | --- |
| App `guestbook` | Path `guestbook`, namespace `guestbook`, automatic sync, `CreateNamespace=true` |
| App `helm-guestbook` | Path `helm-guestbook`, namespace `helm-guestbook`, `CreateNamespace=true`, manual sync |
| App `kustomize-guestbook` | Path `kustomize-guestbook`, namespace `kustomize-guestbook`, automatic sync, `CreateNamespace=true` |

</details>

## 3. Discuss

- Which details did you forget? Which did you never know?
- How would you do this with 200 Applications and 15 teams?
- `argocd admin export` can back up Argo CD. When would your last backup have been taken? Would it include the changes made since?
- How long would your users wait while you rebuild?

Clean up before the next lab:

```bash
make disaster NAME=dr
```

Next: [Lab 3: Life with GitOps](03-gitops.md)
