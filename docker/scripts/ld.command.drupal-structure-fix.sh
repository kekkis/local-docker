#!/usr/bin/env bash
# File
#
# This file contains drupal-structure-fix -command for local-docker script ld.sh.

function ld_command_drupal-structure-fix_exec() {
    if [ -z "$CONTAINER_PHP" ]; then
        echo -e "${Red}ERROR: PHP container name is missing.${Color_Off}"
        echo -e "${Red}Ensure you have variable 'CONTAINER_PHP' set in configuration.${Color_Off}"
        exit 1
    fi
    CONT_ID=$(find_container $CONTAINER_PHP)
    if [ -z "$CONT_ID" ]; then
        echo -e "${Red}ERROR: PHP container ('$CONTAINER_PHP')is not up.${Color_Off}"
        exit 1
    fi
    echo "Creating some folders to project below /var/www"
    docker-compose -f $DOCKER_COMPOSE_FILE exec $CONTAINER_PHP bash -c '[[ ! -d "config/sync" ]] &&  mkdir -vp config/sync'
    docker-compose -f $DOCKER_COMPOSE_FILE exec $CONTAINER_PHP bash -c '[[ ! -d "web/sites/default/files" ]] &&  mkdir -vp web/sites/default/files'
    docker-compose -f $DOCKER_COMPOSE_FILE exec $CONTAINER_PHP bash -c '[[ ! -w "web/sites/default/files" ]] &&  chmod -r 0777 web/sites/default/files'
    docker-compose -f $DOCKER_COMPOSE_FILE exec $CONTAINER_PHP bash -c 'if [ $(su -s /bin/sh www-data -c "test -w \"web/sites/default/files\"") ]; then echo "web/sites/default/files is writable - GREAT!"; else chmod -v a+wx web/sites/default/files; fi'
    docker-compose -f $DOCKER_COMPOSE_FILE exec $CONTAINER_PHP bash -c 'if [ $(su -s /bin/sh www-data -c "test -w \"web/sites/default/settings.php\"") ]; then echo "web/sites/default/settings.php is writable - GREAT!"; else chmod -v a+w web/sites/default/settings.php; fi'
    docker-compose -f $DOCKER_COMPOSE_FILE exec $CONTAINER_PHP bash -c 'mkdir -vp ./web/modules/custom && mkdir -vp ./web/themes/custom'
    docker-compose -f $DOCKER_COMPOSE_FILE exec $CONTAINER_PHP bash -c 'echo > ./web/modules/custom/.gitkeep'
    docker-compose -f $DOCKER_COMPOSE_FILE exec $CONTAINER_PHP bash -c 'echo > ./web/themes/custom/.gitkeep'
}

function ld_command_drupal-structure-fix_help() {
    echo "Tries to fix ownership and file perms issues inside PHP container."
}
