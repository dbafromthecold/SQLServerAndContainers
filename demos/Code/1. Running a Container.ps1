
# https://dbafromthecold.com/2018/09/25/running-sql-server-2019-ctp-in-a-docker-container/




# verify docker version
docker version




# search for an image on the docker hub
docker search mssql




# get tags from MCR
# https://dbafromthecold.com/2019/02/22/displaying-the-tags-within-the-sql-server-docker-repository/
$repo = invoke-webrequest https://mcr.microsoft.com/v2/mssql/server/tags/list
$repo.content




# pull image down to local repository
docker image pull mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-16.04




# verify image is in repository
docker image ls



# run a container
docker container run -d `
-p 15111:1433 `
--env ACCEPT_EULA=Y `
--env MSSQL_SA_PASSWORD=Testing1122 `
--name testcontainer1 `
mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-16.04




# verify container is running
docker container ls -a




# let's clean that command up a bit, just so the output looks nice for this presentation! 
# https://docs.docker.com/engine/reference/commandline/container_ls/
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"




# cool! container is running. Checking the logs...
# https://dbafromthecold.com/2017/02/15/viewing-container-logs/
docker container logs testcontainer1




# In the logs we have....
#
### SQL Server 2019 will run as non-root by default.
### This container is running as user mssql.
# 
# More on this later, but this is a good thing!
# Check out https://dbafromthecold.com/2019/09/18/running-sql-server-containers-as-non-root/




# connect to sql instance
# https://docs.microsoft.com/en-us/sql/tools/mssql-cli
mssql-cli -S 'localhost,15111' -U sa -P Testing1122 -Q "SELECT @@VERSION AS [Version]"




# let's have a look within the container
# https://docs.docker.com/engine/reference/commandline/container_exec/
docker container exec -it testcontainer1 bash




# navigate to system database location
cd /var/opt/mssql/data




# list files
ls -al




# exit the container
exit




# copy a backup file into the container
# https://dbafromthecold.com/2017/05/10/copying-files-fromto-a-container/
docker container cp C:\git\SQLServerAndContainers\demos\DatabaseBackup\DatabaseA.bak `
testcontainer1:/var/opt/mssql/data/



 
# check that the backup file is there
# we can add a command to the end of exec so we don't have to jump into the container
docker container exec testcontainer1 bash -c "ls -al /var/opt/mssql/data/"




# restore database in container 
mssql-cli -S 'localhost,15111' -U sa -P Testing1122 -Q "RESTORE DATABASE [DatabaseA] FROM DISK = '/var/opt/mssql/data/DatabaseA.bak';"




# check databases in container
mssql-cli -S 'localhost,15111' -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"


    

# let's run a couple more containers
docker container run -d `
-p 15222:1433 `
--env ACCEPT_EULA=Y `
--env MSSQL_SA_PASSWORD=Testing1122 `
--name testcontainer2 `
mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-16.04

docker container run -d `
-p 15333:1433 `
--env ACCEPT_EULA=Y `
--env MSSQL_SA_PASSWORD=Testing1122 `
--name testcontainer3 `
mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-16.04




# verify containers are running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"




# stats on container usage
# https://docs.docker.com/engine/reference/commandline/container_stats/
docker container stats




# run a container limiting the resources
# https://dbafromthecold.com/2019/06/19/default-resource-limits-for-windows-vs-linux-containers/
docker container run -d `
-p 15444:1433 `
--cpus=2 `
--memory=2048m `
--env ACCEPT_EULA=Y `
--env MSSQL_SA_PASSWORD=Testing1122 `
--name testcontainer4 `
mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-16.04




# check container is running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"




# check the stats
docker container stats




# clean up
# https://dbafromthecold.com/2017/09/28/the-docker-kill-command/
docker container kill $(docker ps -a -q)
docker container rm $(docker ps -a -q)
