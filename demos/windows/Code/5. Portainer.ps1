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
    New-StoredCredential -Target "SqlDocker" -UserName "sa" -Password "Testing1122" -Persist LocalMachine
}

$cred = Get-StoredCredential -Target "SqlDocker"

# https://dbafromthecold.com/2017/03/01/a-gui-for-docker-container-administration/
# https://portainer.io/


# search for image
docker search portainer



# pull image down to local repository
docker image pull portainer/portainer



# verify image in repository
docker image ls



# run a container
docker container run -d -p 9000:9000 `
    -v "/var/run/docker.sock:/var/run/docker.sock" `
        --name portainer1 portainer/portainer 



# verify container(s)
docker container ls -a



# connect to SQL container
Get-DbaDatabase -SqlInstance 'localhost,15777' -SqlCredential $Cred `
    | Select-Object Name  


        
# clean up
docker container kill portainer1 testcontainer 
docker container rm portainer1 testcontainer
