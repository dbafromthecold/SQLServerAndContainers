# Pre-requisites
Install-Module sqlserver -Force
Install-Module dbatools -Force

Import-Module sqlserver 
Import-Module dbatools

get-module 


# https://dbafromthecold.com/2017/02/08/sql-container-from-dockerfile/


# check local repository
docker images



# build custom image from first dockerfile
docker build -t testimage1 `
    "<INSERT FILEPATH>\Dockerfile1"



# check image is in local repository
docker images



# run container from custom image
docker run -d -p 15555:1433 `
    --name testcontainer5 testimage1



# check container is running
docker ps -a


# check database is in container
Invoke-Sqlcmd -ServerInstance 'localhost,15555' `
    -Username sa -Password 'Testing11@@' `
        -Query 'SELECT name FROM sys.databases ORDER BY name ASC'



# build another custom image from second dockerfile
docker build -t testimage2 `
    "<INSERT FILEPATH>\Dockerfile2"



# verify new custom image is in local repository
docker images



# run container from second custom image
docker run -d -p 15666:15666 `
    --name testcontainer6 testimage2



# verify new container is running    
docker ps -a



# check database is in container
Invoke-Sqlcmd -ServerInstance 'localhost,15666' `
    -Username sa -Password 'Testing11@@' `
        -Query 'SELECT name FROM sys.databases ORDER BY name ASC'



# check version of SQL
Invoke-Sqlcmd -ServerInstance 'localhost,15666' `
    -Username sa -Password 'Testing11@@' `
        -Query 'SELECT @@VERSION AS SQL_Version' | Format-Table -Wrap



# have a look at the info again
docker system df --verbose



# clean up
docker kill testcontainer5 testcontainer6
docker rm testcontainer5 testcontainer6

docker rmi testimage2
