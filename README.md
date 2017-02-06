# Docker Container - nginx+PHP+Node

This container is aimed to support Drupal and Symfony projects all in one. Mainly for personal (development) use, therefore some things may not be "state of the art" and/or simply deprecated.

Use at your own risk. I suggest using this container only for development.

# Installed versions
## Nginx
- uses the official and latest[nginx](https://hub.docker.com/_/nginx/)container as the starting point

## PHP
- currently PHP version 5.6.20

## Node
- [latest version](https://nodejs.org/en/download/current/)(maybe more reasonable to use LTS or stable)

# Main process
As docker containers can start only one main process, this one uses[supervisor](http://supervisord.org/index.html)to launch nginx __and__ php-fpm. Otherwise we could only start nginx __or__ php-fpm, which doesn't make a lot of sense.
