# WordPress Docker

Docker based multisite WordPress setup.

## Requirements

- Docker
- Docker compose

## Installation

1. If you have a database dump, place it at `./database.sql`
2. Copy `.env.example` to `.env`
3. Run `docker-compose up` and wait for containers to start
4. Run `docker-compose run composer install` to install composer packages
5. Open `http://localhost/wp-admin` in your browser

## Some commands/tools

1. composer: `docker-compose run composer`
2. WP-cli: `docker-compose run wp-cli`
