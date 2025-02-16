
# https://dbafromthecold.com/2016/11/16/sql-server-containers-part-one/


# verify docker service is running
systemctl status docker



# verify docker is responding to commands
docker version



# search for an image on the docker hub
docker search microsoft/mssql



# get tags from MCR
GET https://mcr.microsoft.com/v2/mssql/server/tags/list



# pull image down to local repository
docker image pull mcr.microsoft.com/mssql/server:2019-GDR1-ubuntu-16.04



# verify image is in repository
docker image ls



# run a container
docker container run -d -p 15111:1433 \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--name testcontainer1 \
mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-16.04



# verify container is running
docker container ls -a



# cool! container is running. Checking the logs...
docker container logs testcontainer1



# connect to sql instance
mssql-cli -S 'localhost,15111' -U sa -P Testing1122



# get sql version
SELECT @@VERSION;



# exit mssql-cli
exit



# let's have a look within the container
docker container exec -it testcontainer1 bash



# navigate to system database location
cd /var/opt/mssql/data



# list files
ls -al



# exit the container
exit



# copy a backup file into the container
docker container cp ~/git/SQLServerAndContainers/DatabaseBackup/DatabaseA.bak \
        testcontainer1:/var/opt/mssql/data/


 
# check that the backup file is there
docker container exec -it testcontainer1 bash



# navigate to directory
cd /var/opt/mssql/data/



# list directory contents
ls -al



# exit container
exit



# connect to sql instance
mssql-cli -S 'localhost,15111' -U sa -P Testing1122



# restore database in container          
RESTORE DATABASE [DatabaseA] FROM DISK = '/var/opt/mssql/data/DatabaseA.bak';



# check databases in container
select name from sys.databases;



# exit mssql-cli
exit


    
# let's run a couple more containers
docker container run -d -p 15222:1433 \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--name testcontainer2 \
mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-16.04

docker container run -d -p 15333:1433 \
--env ACCEPT_EULA=Y \
--env SA_PASSWORD=Testing1122 \
--name testcontainer3 \
mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-16.04



# verify containers are running
docker container ls -a



# stats on container usage
docker container stats



# run a container limiting the resources
docker container run -d -p 15444:1433 \
--cpus=2 --memory=2048m \
--env ACCEPT_EULA=Y --env SA_PASSWORD=Testing1122 \
--name testcontainer4 \
mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-16.04



# check container is running
docker container ls -a



# check the stats
docker container stats



# clean up
docker container rm $(docker ps -a -q) -f
