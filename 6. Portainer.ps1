# https://dbafromthecold.com/2017/03/01/a-gui-for-docker-container-administration/
# https://portainer.io/


# search for image
docker search portainer



# pull image down to local repository
docker pull portainer/portainer



# verify image in repository
docker images



# run a container
docker run -d -p 9000:9000 `
    -v "/var/run/docker.sock:/var/run/docker.sock" `
        --name portainer1 portainer/portainer 



# verify container(s)
docker ps -a



# connect to SQL container
Invoke-Sqlcmd -ServerInstance 'localhost,15789' `
    -Username sa -Password 'Testing11@@' `
        -Query 'SELECT name FROM sys.databases ORDER BY name ASC'


        
# clean up
docker kill portainer1 testcontainer 
docker rm portainer1 testcontainer
