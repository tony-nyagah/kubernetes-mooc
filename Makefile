# Release an exercise: make <exercise-number> APP=<app-folder>
# e.g. make 1.1 APP=log-output
#
# Builds and pushes nyagah/<app>:<exercise>, commits any changes,
# tags the commit with the exercise number and creates a GitHub release.

DOCKER_USER := nyagah
APPS := $(patsubst %/Dockerfile,%,$(wildcard */Dockerfile))

.PHONY: help
help:
	@echo "Usage: make <exercise-number> APP=<app-folder>"
	@echo "  e.g. make 1.1 APP=log-output"
	@echo ""
	@echo "Builds and pushes $(DOCKER_USER)/<app>:<exercise>, commits any changes,"
	@echo "tags the commit with the exercise number and creates a GitHub release."
	@echo ""
	@echo "Apps: $(APPS)"

1.% 2.% 3.% 4.% 5.%:
	@test -n "$(APP)" || { echo "Usage: make $@ APP=<app-folder>"; exit 1; }
	@test -d "$(APP)" || { echo "No such app folder: $(APP)"; exit 1; }
	@! git rev-parse -q --verify "refs/tags/$@" >/dev/null || { echo "Tag $@ already exists"; exit 1; }
	docker build -t $(DOCKER_USER)/$(APP):$@ $(APP)
	docker push $(DOCKER_USER)/$(APP):$@
	git add -A
	git diff --cached --quiet || git commit -m "feat($(APP)): exercise $@"
	git tag $@
	git push origin HEAD
	git push origin $@
	gh release create $@ --title "$@" --notes "Exercise $@: $(DOCKER_USER)/$(APP):$@"
	@echo ""
	@echo "Submission link: $$(gh repo view --json url -q .url)/tree/$@"
