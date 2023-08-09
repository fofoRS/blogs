#!/bin/bash
echo "Starting event-collector application"

echo -n "build docker image? Y/N > "
read text
if  [ $text = "Y" ]; then
  echo "building docker image"
  docker build --target local-development -f ./Dockerfile -t rrojas/event-collector:local .
  if [ $? = 0 ]; then
    echo "image created"
  else
    echo "image creation failed"
    exit  1
  fi
fi

echo "starting container for event-collector"
docker run --rm --name event-collector --network local-development -p 8081:8081 -p 8000:8000 rrojas/event-collector:local
