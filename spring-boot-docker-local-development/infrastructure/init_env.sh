#!/bin/bash

echo initilizing local environment

docker images | grep "rabbitmq"
if [ $? = 1 ]; then
  echo rabbitmq image not found locally, pulling remote image
  docker pull rabbitmq:3-managemen
fi
docker images | grep "postgres"
if [ $? = 1 ]; then
  echo postgres image not found locally, pulling remote image
  docker pull postgres:latest
fi
echo recreating local-development network
docker network rm local-development
if [ $? = 1 ]; then
  echo cannot delete network, may does not exists
fi
if docker network create local-development; then
  echo "Network local-development create"
else
  echo "Network cannot be created"
fi
printf "\033[32mlocal development is ready to be used\033[0m\n"

