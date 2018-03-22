# Pre-requisites
Install-Module CredentialManager -Force
Install-Module dbatools -Force
Install-Module sqlserver -Force

Import-Module CredentialManager
Import-Module dbatools
Import-Module sqlserver 

Get-Module 

Set-Location C:\


# set credentials to connect to SQL instances
$cred = Get-StoredCredential -Target "SqlDocker"

if (!$cred){
    New-StoredCredential -Target "SqlDocker" -UserName "sa" -Password "Testing1122" -Persist LocalMachine
}


Get-StoredCredential -Target "SqlDocker"

# https://dbafromthecold.com/2016/11/16/sql-server-containers-part-one/


# verify docker service is running
Get-Service *docker*



# verify docker is responding to commands
docker version



# search for an image on the docker hub
docker search microsoft/mssql



# pull image down to local repository
docker pull microsoft/mssql-server-linux:latest



# verify image is in repository
docker images



# run a container
docker run -d -p 15111:1433 `
    --env SA_PASSWORD=Testing1122 `
        --name testcontainer1 `
            microsoft/mssql-server-linux:latest



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
        --env SA_PASSWORD=Testing1122 `
            --name testcontainer1 microsoft/mssql-server-linux:latest



# verify container is running
docker ps -a



# cool! container is running. Checking the logs...
docker logs testcontainer1



# check version of SQL
$srv = Connect-DbaInstance 'localhost,15111' -Credential $cred
    $srv.Information
    $srv.Edition
    $srv.HostDistribution
    $srv.HostPlatform
    $srv.Version



# let's have a look within the container
docker exec -it testcontainer1 bash



# copy a backup file into the container
$Filepath = ""
docker cp $Filepath\DatabaseA.bak `
        testcontainer1:'/var/opt/mssql/data/'


 

# check that the backup file is there
docker exec -it testcontainer1 bash



# restore database in container
Restore-DbaDatabase -SqlInstance 'localhost,15111' `
    -SqlCredential $cred `
        -Path '/var/opt/mssql/data/DatabaseA.bak' `
            -DestinationDataDirectory '/var/opt/mssql/data/' `
                -DestinationLogDirectory '/var/opt/mssql/log'

            

# check databases in container
$srv = Connect-DbaInstance 'localhost,15111' -Credential $cred
    $srv.Databases



# let's run a couple more containers
docker run -d -p 15222:1433 `
--env ACCEPT_EULA=Y `
    --env SA_PASSWORD=Testing1122 `
        --name testcontainer2 microsoft/mssql-server-linux:latest

docker run -d -p 15333:1433 `
    --env ACCEPT_EULA=Y `
        --env SA_PASSWORD=Testing1122 `
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
            --env ACCEPT_EULA=Y --env SA_PASSWORD=Testing1122 `
                --name testcontainer4 microsoft/mssql-server-linux:latest



# check container is running
docker ps -a



# check the stats
docker stats



# clean up
docker kill testcontainer1 testcontainer2 testcontainer3 testcontainer4
docker rm testcontainer1 testcontainer2 testcontainer3 testcontainer4

