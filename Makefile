include .env
export
PROJECT_ROOT := $(subst \,/,$(CURDIR))
export PROJECT_ROOT

env-up:
	docker compose up -d company_structure_postgres
env-down: 
	docker compose down company_structure_postgres