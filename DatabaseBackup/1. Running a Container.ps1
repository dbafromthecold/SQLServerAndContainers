# Pre-requisites
Install-Module sqlserver -Force
Install-Module dbatools -Force

Import-Module sqlserver 
Import-Module dbatools

get-module 


# https://dbafromthecold.com/2016/11/16/sql-server-containers-part-one/


# verify docker service is running
Get-Service *docker*



# verify docker is responding to commands
docker version



# search for an image on the docker hub
docker search microsoft/mssql



# pull image down to local repository
docker pull microsoft/mssql-server-linux:latest



# verify image is in local repository
docker images



# run a container
docker run -d -p 15111:1433 `
    --env SA_PASSWORD=Testing11@@ `
        --name testcontainer1 microsoft/mssql-server-linux:latest



# verify container is running
docker ps



# check status of container
docker ps -a



# hmmm, container isn't running. Check the logs
docker logs testcontainer1



# d'oh! Need to accept the EULA. Delete current container
docker rm testcontainer1



# run another container, accepting the EULA
docker run -d -p 15111:1433 `
    --env ACCEPT_EULA=Y `
        --env SA_PASSWORD=Testing11@@ `
            --name testcontainer1 microsoft/mssql-server-linux:latest



# verify container is running
docker ps -a



# cool! container is running. Checking the logs...
docker logs testcontainer1



# check version of SQL
Invoke-Sqlcmd -ServerInstance 'localhost,15111' `
    -Username sa -Password 'Testing11@@' `
        -Query 'SELECT @@VERSION AS SQL_Version' | Format-Table -Wrap



# let's have a look within the container
docker exec -it testcontainer1 bash



# copy a backup file into the container
docker cp <INSERT FILEPATH>\DatabaseA.bak `
        testcontainer1:'/var/opt/mssql/data/'


 

# check that the backup file is there
docker exec -it testcontainer1 bash



# restore database in container
$cred = Get-Credential

Restore-DbaDatabase -SqlInstance 'localhost,15111' `
    -SqlCredential $cred `
        -Path '/var/opt/mssql/data/DatabaseA.bak' `
            -DestinationDataDirectory '/var/opt/mssql/data/' `
                -DestinationLogDirectory '/var/opt/mssql/log'



# recheck databases in container
Invoke-Sqlcmd -ServerInstance 'localhost,15111' `
    -Username sa -Password 'Testing11@@' `
        -Query 'SELECT name FROM sys.databases ORDER BY name ASC'



# let's run a couple more containers
docker run -d -p 15222:1433 `
--env ACCEPT_EULA=Y `
    --env SA_PASSWORD=Testing11@@ `
        --name testcontainer2 microsoft/mssql-server-linux:latest

docker run -d -p 15333:1433 `
    --env ACCEPT_EULA=Y `
        --env SA_PASSWORD=Testing11@@ `
            --name testcontainer3 microsoft/mssql-server-linux:latest



# verify containers are running
docker ps -a



# have a look at the system stats
docker system df --verbose



# stats on container usage
docker stats



# run a container limiting the resources
docker run -d -p 15444:1433 `
    --cpus=2 --memory=2048m `
            --env ACCEPT_EULA=Y --env SA_PASSWORD=Testing11@@ `
                --name testcontainer4 microsoft/mssql-server-linux:latest



# check container is running
docker ps -a



# check the stats
docker stats



# clean up
docker kill testcontainer1 testcontainer2 testcontainer3 testcontainer4
docker rm testcontainer1 testcontainer2 testcontainer3 testcontainer4

