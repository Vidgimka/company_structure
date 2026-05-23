include .env
export
PROJECT_ROOT := $(subst \,/,$(CURDIR))
export PROJECT_ROOT

env-up:
	@docker compose up -d company_structure_postgres
env-down: 
	@docker compose down company_structure_postgres

env-cleanup:
	@echo "Clear all environment volume files? [y/N]:"
	@cmd /v:on /c "set /p ans=& if /i \"!ans!\"==\"y\" ( \
		docker compose down company_structure_postgres && \
		rmdir /s /q out\pgdata && \
		echo Environment files deleted) \
		else (echo Deletion cancelled)"

env-forwarder-up:
	@docker compose up -d port-forwarder

env-forwarder-down:
	@docker compose down port-forwarder

migrate-goose-create:
	@if "$(name)"=="" ( \
		echo Missing required parameter name && \
		exit 1 \
	)
	@docker compose run --rm --entrypoint goose \
	company_structure_migrate-goose create "$(name)" sql

migrate-goose-up:
	@make migrate-goose-action action=up

migrate-goose-down:
	@make migrate-goose-action action=down

migrate-goose-action:
	@if "$(action)"=="" ( \
	echo Missing required parameter action && \
	exit 1 \
	)
	@docker compose run --rm company_structure_migrate-goose $(action)