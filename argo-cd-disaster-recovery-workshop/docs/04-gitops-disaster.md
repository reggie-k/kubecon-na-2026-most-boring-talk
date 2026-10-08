# Lab 4: Disaster #2

## 1. Lose the cluster again

```bash
make disaster NAME=primary
```

## 2. Recover

```bash
make cluster NAME=dr
make bootstrap
```

That is the whole runbook. The script prints how long recovery took.

## 3. Check what came back

Open the UI, or run:

```bash
argocd app list
kubectl get namespaces
```

Everything is back, including `my-app` and the `guestbook-qa` environment you added in Lab 3. You did not have to remember any of it.

## 4. Discuss

- Compare this recovery with Lab 2. How long did each take, and how complete was each one?
- What did you have to remember this time? (Only the repository URL.)
- Could someone who has never seen this setup run the recovery?

Next: [Lab 5: Wrap-up](05-wrap-up.md)
