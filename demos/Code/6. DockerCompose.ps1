
# https://docs.docker.com/compose/



# navigate to directory
cd C:\git\SQLServerAndContainers\demos\Compose



# view compose file
cat docker-compose.yaml



# view dockerfile
cat dockerfile



# view environment file
cat sqlserver.env



# spin up container
docker-compose up -d



# view custom network
docker network ls



# view image built
docker image ls



# view volumes created
docker volume ls



# view container
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"



# connect to sql in container
mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "SELECT @@VERSION"



# shutdown container
docker-compose down



# clean up
docker container rm $(docker container ls -aq) -f
docker volume prune -f
docker image rm compose_sqlserver1