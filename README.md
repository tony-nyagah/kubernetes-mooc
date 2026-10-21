# Kubernetes MOOC

Solutions to: https://courses.mooc.fi/org/uh-cs/courses/devops-with-kubernetes-2026

## Workflow per exercise

Use the exercise number as both the git tag and the image tag (git tag `1.1` ↔ `nyagah/log-output:1.1`).

`make <exercise-number> APP=<app-folder>` (e.g. `make 1.1 APP=log-output`) runs the build, push, commit, tag and release steps below in one go.

```shell
# Build from the repo root, check it runs, then push to Docker Hub
docker build -t nyagah/log-output:<exercise-number> log-output
docker run --rm nyagah/log-output:<exercise-number>
docker push nyagah/log-output:<exercise-number>
```

```shell
# Run it in Kubernetes
kubectl create deployment log-output --image=nyagah/log-output:<exercise-number>
```

```shell
# Commit, tag and push
git add -A
git commit -m "feat(log-output): exercise <exercise-number>"
git tag <exercise-number>
git push origin main --tags
```

```shell
# Optional: make a GitHub release from the tag
gh release create <exercise-number> --title "<exercise-number>" --notes "Exercise <exercise-number>"
```

To tag an older commit: `git tag <exercise-number> <commit-sha>`.

## Exercises

- [1.1](https://github.com/tony-nyagah/kubernetes-mooc/tree/1.1)
