SRC = $(wildcard lib/*.py)
PKG = lib.zip

FN     = $(shell terraform output function_name)
URL1   = $(shell terraform output base_url)
URL2   = $(shell terraform output custom_url)
REGION = $(shell terraform output region)

all: help

clean: ## remove artifacts
	-rm lib.zip 2> /dev/null

build: $(PKG) ## build artifacts

verify: build ## validate terraform config
	terraform validate

plan: verify ## show deployment plan
	terraform plan

deploy: verify ## deploy terraform config
	terraform apply --auto-approve

destroy: ## destroy all terraform deployed resources
	terraform destroy --auto-approve

validate: deploy ## verify deployment succeeded
	aws lambda invoke \
		--invocation-type RequestResponse \
		--function-name $(FN) \
		--region $(REGION) \
		--payload '{"name":"john","qwer":"asdr"}' \
		--log-type Tail /dev/stdout | jq -r .LogResult | base64 -D
	curl $(URL1)
	curl -iL $(URL2)

$(PKG): $(SRC) ## build zip package
	cd lib; zip -rq9 ../$(PKG) . -i \*.py


help: ## Display help text.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'


.PHONY: all clean build verify deploy validate help

# vi:se nowrap:
