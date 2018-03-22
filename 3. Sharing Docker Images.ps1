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


# https://dbafromthecold.com/2016/11/30/sql-server-containers-part-three/



# log into the docker hub
$PasswordFile = "C:\Git\dbafromthecold\SQLServerAndContainersDemo\dockerlogin.txt"
Get-Content $PasswordFile `
    | docker login --username dbafromthecold --password-stdin



# check images
docker images



# tag custom image with repository name
docker tag testimage1 dbafromthecold/testsqlrepository:linuxdemo



# verify image has been tagged
docker images



# push image to the hub
docker push dbafromthecold/testsqlrepository:linuxdemo




# verify image is on the hub
docker search dbafromthecold



# clean up
docker rmi dbafromthecold/testsqlrepository:linuxdemo testimage1
