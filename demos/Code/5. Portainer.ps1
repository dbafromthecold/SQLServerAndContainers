
# https://dbafromthecold.com/2017/03/01/a-gui-for-docker-container-administration/
# https://portainer.io/




# search for image
docker search portainer




# pull image down to local repository
docker pull portainer/portainer




# verify image in repository
docker image ls




# run a container
docker container run -d `
-p 9000:9000 `
-v /var/run/docker.sock:/var/run/docker.sock `
--name portainer1 `
portainer/portainer 




# verify container
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"




# connect to SQL container
mssql-cli -S localhost,15789 -U sa -P Testing1122 -Q "SELECT @@VERSION AS [Version];"



        
# clean up
docker container kill portainer1 testcontainer 
docker container rm portainer1 testcontainer
