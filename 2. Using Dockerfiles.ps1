# Pre-requisites
Install-Module CredentialManager -Force
Install-Module dbatools -Force

Import-Module CredentialManager
Import-Module dbatools


Get-Module 

Set-Location C:\


# set credentials to connect to SQL instances
$cred = Get-StoredCredential -Target "SqlDocker"

if (!$cred){
    New-StoredCredential -Target "SqlDocker" -UserName "sa" -Password "Testing1122" -Persist Session
}


# https://dbafromthecold.com/2017/02/08/sql-container-from-dockerfile/



# check local repository
docker images



# build custom image
$Filepath = "C:\Git\dbafromthecold\SQLServerAndContainersDemo\Dockerfiles"
docker build -t testimage1 $Filepath\Dockerfile1



# check local repository
docker images



# run container from custom image
docker run -d -p 15555:1433 `
    --name testcontainer5 `
        testimage1



# check container is running
docker ps -a



# check databases in container
Get-DbaDatabase -SqlInstance 'localhost,15555' -SqlCredential $Cred `
    | Select-Object Name



# build another custom image from second dockerfile
$Filepath = "C:\Git\dbafromthecold\SQLServerAndContainersDemo\Dockerfiles"
docker build -t testimage2 $Filepath\Dockerfile2



# verify new custom image is in local repository
docker images



# run container from second custom image
docker run -d -p 15666:15666 `
    --env SA_PASSWORD=Testing1122 `
        --name testcontainer6 `
            testimage2



# verify new container is running    
docker ps -a



# check databases in container
Get-DbaDatabase -SqlInstance 'localhost,15666' -SqlCredential $Cred `
    | Select-Object Name



# check version of SQL
Connect-DbaInstance -SqlInstance 'localhost,15666' -Credential $cred `
    | Select-Object Product, HostDistribution, HostPlatform, Version, Edition



# clean up
docker rm $(docker ps -a -q) -f

docker rmi testimage2
