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


# https://dbafromthecold.com/2017/02/08/sql-container-from-dockerfile/



# check local repository
docker images



# build custom image
$Filepath = "<ENTER FILEPATH>"
docker build -t testimage1 "$Filepath\Dockerfile1"



# check local repository
docker images



# run container from custom image
docker run -d -p 15555:1433 `
    --name testcontainer5 testimage1



# check container is running
docker ps -a


# check databases in container
$srv = Connect-DbaInstance 'localhost,15555' -Credential $cred
    $srv.Databases



# build another custom image from second dockerfile
$Filepath = "<ENTER FILEPATH>"
docker build -t testimage2 "$Filepath\Dockerfile2"



# verify new custom image is in local repository
docker images



# run container from second custom image
docker run -d -p 15666:15666 `
    --name testcontainer6 testimage2



# verify new container is running    
docker ps -a



# check databases in container
$srv = Connect-DbaInstance 'localhost,15666' -Credential $cred
    $srv.Databases



# check version of SQL
$srv = Connect-DbaInstance 'localhost,15666' -Credential $cred
    $srv.Information
    $srv.Edition
    $srv.HostDistribution
    $srv.HostPlatform
    $srv.Version



# clean up
docker kill testcontainer5 testcontainer6
docker rm testcontainer5 testcontainer6

docker rmi testimage2
