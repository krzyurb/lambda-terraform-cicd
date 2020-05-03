DOCKER_COMPOSE = docker-compose

init:
	terraform apply

up:
	$(DOCKER_COMPOSE) up -d --remove-orphans

logs:
	$(DOCKER_COMPOSE) logs -f $(filter-out $@,$(MAKECMDGOALS))

down:
	$(DOCKER_COMPOSE) down

reboot:
	make down
	make up
