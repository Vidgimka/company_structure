include .env
export
PROJECT_ROOT := $(subst \,/,$(CURDIR))
export PROJECT_ROOT

env-up:
	docker compose up -d company_structure_postgres
env-down: 
	docker compose down company_structure_postgres

env-cleanup:
	@echo "Clear all environment volume files? [y/N]:"
	@cmd /v:on /c "set /p ans=& if /i \"!ans!\"==\"y\" ( \
		docker compose down company_structure_postgres && \
		rmdir /s /q out\pgdata && \
		echo Environment files deleted) \
		else (echo Deletion cancelled)"

migrate-create:
	@if "$(seq)"=="" ( \
		echo Missing required parameter seq && \
		exit 1 \
	)
	@docker compose run --rm company_structure_migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"