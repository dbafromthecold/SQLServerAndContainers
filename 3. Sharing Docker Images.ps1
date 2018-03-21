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


# https://dbafromthecold.com/2016/11/30/sql-server-containers-part-three/



# log into the docker hub
$Filepath = "Enter Filepath to password text file"
Get-Content $filepath `
                | docker login --username username --password-stdin



# check images
docker images



# tag custom image with repository name
docker tag testimage1 "yourreponame"/testsqlrepository:linuxdemo



# verify image has been tagged
docker images



# push image to the hub
docker push "yourreponame"/testsqlrepository:linuxdemo




# verify image is on the hub
docker search "yourreponame"



# clean up
docker rmi "yourreponame"/testsqlrepository:linuxdemo testimage1
