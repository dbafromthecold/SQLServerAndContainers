
# https://dbafromthecold.com/2017/03/01/a-gui-for-docker-container-administration/
# https://portainer.io/


# search for image
docker search portainer



# pull image down to local repository
docker pull portainer/portainer



# verify image in repository
docker image ls



# run a container
docker container run -d -p 9000:9000 \
-v /var/run/docker.sock:/var/run/docker.sock \
--name portainer1 portainer/portainer 



# verify container(s)
docker container ls -a



# connect to SQL container
mssql-cli -S localhost,15789 -U sa -P Testing1122



# run a command
select @@VERSION;



# exit mssql-cli
exit


        
# clean up
docker container kill portainer1 testcontainer 
docker container rm portainer1 testcontainer
