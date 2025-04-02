# Makefile
NAME = inception

all: prepare build up

prepare:
	@mkdir -p /home/miwasa/data/mariadb
	@mkdir -p /home/miwasa/data/wordpress

build:
	@docker-compose -f srcs/docker-compose.yml build

up:
	@docker-compose -f srcs/docker-compose.yml up -d

down:
	@docker-compose -f srcs/docker-compose.yml down

clean: down
	@docker system prune -a

fclean: clean
	@docker volume rm $$(docker volume ls -q)
	@sudo rm -rf /home/miwasa/data/mariadb/*
	@sudo rm -rf /home/miwasa/data/wordpress/*

re: fclean all

.PHONY: all prepare build up down clean fclean re
