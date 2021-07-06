# inspiration from https://github.com/jupyter/docker-stacks
.PHONY: dev

# Use bash for inline if-statements in target
SHELL:=bash
TAG:=latest
OWNER:=illumidesk
VENV_NAME?=venv
VENV_BIN=$(shell pwd)/${VENV_NAME}/bin
VENV_ACTIVATE=. ${VENV_BIN}/activate

PYTHON=${VENV_BIN}/python3

# Linter
HADOLINT="${HOME}/hadolint"

help:
# credits:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
# http://github.com/jupyter/docker-stacks
	@echo "illumidesk/jupyter-pluto-proxy"
	@echo "====================="
	@echo "Run one of the commands below with the 'make ...' command, i.e. 'make dev'."
	@echo
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: venv ## build the latest image for a stack
	@docker build -t $(OWNER)/jupyter-pluto-notebook:$(TAG) .

clean-all: ## remove built images and running containers (including those w/ exit status)
	@docker rm -f $(shell docker ps -aq)

lint: venv ## lint the dockerfile(s)
	@echo "Linting tests with flake8 ..."
	${VENV_BIN}/flake8
	@echo "Linting with flake8 done!"
	@echo "Applying black updates to test files..."
	${VENV_BIN}/black jupyter_pluto_proxy
	@echo "Source formatting with black done!"

venv: ## install hadolint create virtual environment
	test -d $(VENV_NAME) || virtualenv -p python3 $(VENV_NAME)
	${PYTHON} -m pip install -r dev-requirements.txt