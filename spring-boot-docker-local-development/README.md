## spring-boot-docker-local-development

Very simplistic project that counts with three services that looks for simulate a microservices based application.
*I know there are many other components, technics  and practices to consider this as a microservice architecture, but this setup fits the goals of this repo*
which is to show how set up a local environment using Docker, Docker-Compose and Docker's multi stage capabilities to run a local environment easily, 
helping us to spin up multiple services and save many hours from installing, configuring and troubleshooting. :) 

### MODULE STRUCTURE

    - spring-boot-docker-local-development
      -- api-gateway: api entry point, connects to discovery service to discovers services and route incoming request to them
      -- discovery-service: eureka server
      -- event-collertor: backend service that expose only one endpoint that logs the request body
      -- infrastructure: some helper script and the docker-compose file to start the api-gateway and discovery-service containers

## System Requirements

1. you need to have docker daemon installed and running locally, 
   if not installed; you can find the installation instruction [here](https://docs.docker.com/engine/install/)
2. In case you want run the services or compile the projects outside of docker, you will need both JAVA 17 or newer and MAVEN installed locally 

## HOW TO SET UP THE LOCAL ENVIRONMENT
In order to run the services locally we have to create couple infrastructure components before, 
so we can run our under-development services successfully.

**PLEASE, SET YOU POSITION AT spring-boot-docker-local-development FOLDER** 
the command and paths are relative to this folder

1. At root level, please execute the following command, it will pull postgres, rabbit, 
   and create a bridge network. **postgres and rabbit they won't be used for now**.
    >    ./infrastructure init_env.sh
    >
    >    #if failed due to execution permission, run: sudo chmod 755 /infrastructure/init_env.sh and run the previous command again.

2. run discovery-service & api-gateway, they already exist in docker hub, so won't require to build locally, 
   1. if you still want to build them and use your own images, run the following commands
      **The building of this two images might take some time to finish, be patient :P**
      > docker-compose -f infrastructure/local.docker-compose.yml up --build
   
   2. in case you want to use the remote images, run the following commands
      > docker-compose -f infrastructure/docker-compose.yml up
      
**CHECKPOINT: So far we have created the required network docker object. 
We also have the api-gateway and discovery-service running, now we can consider the environment ready to be used. 
From here we just have to run the container of our service(s) we're  working on and see how it connects with the rest of our local environment components**

3. Let's build and run event-collector service to see how it registers to discovery-service and be discovered by api-gateway.
   1. Compile, Package and ship .jar into a docker image in a single step by leveraging Docker multi-stage feature
      > docker build --target local-development -f ./event-collector/Dockerfile -t event-collector:local ./event-collector
   2. Run container
      > docker run --rm --name event-collector --network local-development -p 8081:8081 -p 8000:8000 event-collector:local 
       
   here we expose two post to the host's port, (:8080) is for the application to list to http requests, (:8000) is to expose the server debug port,
   so we can connect a debugger client, for example Intellij debugger.

4. Call endpoint in event-collector
   > curl -H "Content-Type:application/json" http:/Ø/localhost:8080/event-collector/api/v1/events -d '{"eventType":"user-click"}' -i 

if the first call result in a 404, wait few seconds and try again. API gateway take some time to update its discovery registry

We can highlight a couple of things from the above curl call: 
1.  Call hit api-gateway service first, 
and we can say that by looking at the port (:8080) which is the port the api-gateway is listen on.
2. The request path starts with **/event-collector** which is the name of the service, 
the reason we can use the service name here is because api-gateway takes leverage of discovery service to 
get the target service's api to route the request.

## Final Thoughts
With this strategy for local development environment we could see that the setup's complexity decreases significantly by using some of Docker's feature like docker-compose and multi-stage builds. 
One of the biggest benefits of this configuration is how it frees us up from the installation of many local services and runtimes like:
- JAVA
- Maven 
- Backend Services such (Data Bases, Message Brokers, etc)
- Architecture core components (api-gateways, config-servers, discovery-servers) 
   *Even when this service were built by ours, 
   it doesn't make sense to have the source code in our local or even set them up to run locally. 
   Unless we're doing changes on one of these services.*
