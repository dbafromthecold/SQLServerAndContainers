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


# https://dbafromthecold.com/2017/06/21/persisting-data-in-docker-containers-partone/

## Mounting volumes from the host


# create volume on host
if(Test-Path("C:\SQLData")){
    Remove-Item C:\SQLData -Recurse -Force
}

New-Item C:\SQLData -ItemType Directory



# run a container mapping the host volume
docker run -d -p 15777:1433 `
    -v C:\SQLData:/sqlserver `
        --env ACCEPT_EULA=Y --env SA_PASSWORD=Testing1122 `
            --name testcontainer7 microsoft/mssql-server-linux:latest



# verify container is running
docker ps -a            



# verify volume is mapped
docker exec -it testcontainer7 bash



# create a database within the container
Invoke-Sqlcmd -ServerInstance 'localhost,15777' `
    -Username sa -Password 'Testing1122' `
        -Query 'CREATE DATABASE [DatabaseD]
                ON PRIMARY
                    (NAME = N''DatabaseD'', FILENAME = N''/sqlserver/DatabaseD.mdf'')
                LOG ON
                    (NAME = N''DatabaseD_log'', FILENAME = N''/sqlserver/DatabaseD_log.ldf'')'



# check database is there
$srv = Connect-DbaInstance 'localhost,15777' -Credential $cred
    $srv.Databases



# create a test table and insert some data
$srv = Connect-DbaInstance 'localhost,15777' -Credential $cred
    $db = $srv.Databases | Where-Object {$_.Name -eq "DatabaseD"}
        $db.Query("CREATE TABLE dbo.TestTable1(ID INT);")
            $db.Query("INSERT INTO dbo.TestTable1(ID) SELECT TOP 100 1 FROM sys.all_columns")



# query the test table
$srv = Connect-DbaInstance 'localhost,15777' -Credential $cred
    $db = $srv.Databases | Where-Object {$_.Name -eq "DatabaseD"}
        $db.Query("SELECT COUNT(*) AS Records FROM dbo.TestTable1")               



# blow away container        
docker kill testcontainer7
docker rm testcontainer7



# confirm container is gone
docker ps -a



# verify database files still in host folder
Get-ChildItem C:\SQLData



# spin up another container with the volume mapped
docker run -d -p 15888:1433 `
    -v C:\SQLData:/sqlserver `
        --env ACCEPT_EULA=Y --env SA_PASSWORD=Testing1122 `
            --name testcontainer8 microsoft/mssql-server-linux:latest



# verify container is running
docker ps -a



# check database is there
$srv = Connect-DbaInstance 'localhost,15888' -Credential $cred
    $srv.Databases



# 'course not! We need to attach it, first check the files are there
docker exec -it testcontainer8 bash



# now attach the database
$fileStructure = New-Object System.Collections.Specialized.StringCollection
    $fileStructure.Add('/sqlserver/DatabaseD.mdf')
    $filestructure.Add('/sqlserver/DatabaseD_log.ldf')

Mount-DbaDatabase -SqlInstance "localhost,15888" `
    -Database DatabaseD -SqlCredential $cred `
        -FileStructure $fileStructure



# check database is there
$srv = Connect-DbaInstance 'localhost,15888' -Credential $cred
    $srv.Databases
    


# query the test table
$srv = Connect-DbaInstance 'localhost,15888' -Credential $cred
    $db = $srv.Databases | Where-Object {$_.Name -eq "DatabaseD"}
        $db.Query("SELECT COUNT(*) AS Records FROM dbo.TestTable1") 



# clean up
docker kill testcontainer8
docker rm testcontainer8





# https://dbafromthecold.com/2017/06/28/persisting-data-in-docker-containers-part-two/
## Named Volumes


# create the named volume
docker volume create sqlserver


# verify named volume is there
docker volume ls


# spin up a container with named volume mapped
docker run -d -p 15999:1433 `
    -v sqlserver:/sqlserver `
        --env ACCEPT_EULA=Y --env SA_PASSWORD=Testing1122 `
            --name testcontainer9 microsoft/mssql-server-linux:latest



# check the container is running
docker ps -a            


# create database on the named volume
Invoke-Sqlcmd -ServerInstance 'localhost,15999' `
    -Username sa -Password 'Testing1122' `
        -Query 'CREATE DATABASE [DatabaseE]
                ON PRIMARY
                    (NAME = N''DatabaseE'', FILENAME = N''/sqlserver/DatabaseE.mdf'')
                LOG ON
                    (NAME = N''DatabaseE_log'', FILENAME = N''/sqlserver/DatabaseE_log.ldf'')'

                

# check database is there
$srv = Connect-DbaInstance 'localhost,15999' -Credential $cred
    $srv.Databases                           



# create a test table and insert some data
$srv = Connect-DbaInstance 'localhost,15999' -Credential $cred
$db = $srv.Databases | Where-Object {$_.Name -eq "DatabaseE"}
    $db.Query("CREATE TABLE dbo.TestTable2(ID INT);")
        $db.Query("INSERT INTO dbo.TestTable2(ID) SELECT TOP 200 1 FROM sys.all_columns")



# query the test table
$srv = Connect-DbaInstance 'localhost,15999' -Credential $cred
    $db = $srv.Databases | Where-Object {$_.Name -eq "DatabaseE"}
        $db.Query("SELECT COUNT(*) AS Records FROM dbo.TestTable2")     



# blow away container
docker kill testcontainer9
docker rm testcontainer9



# check that named volume is still there
docker volume ls



# spin up another container
docker run -d -p 16100:1433 `
    -v sqlserver:/sqlserver `
        --env ACCEPT_EULA=Y --env SA_PASSWORD=Testing1122 `
            --name testcontainer10 microsoft/mssql-server-linux:latest



# verify container is running
docker ps -a



# now attach the database
$fileStructure = New-Object System.Collections.Specialized.StringCollection
    $fileStructure.Add('/sqlserver/DatabaseE.mdf')
    $filestructure.Add('/sqlserver/DatabaseE_log.ldf')

Mount-DbaDatabase -SqlInstance "localhost,16100" `
    -Database DatabaseE -SqlCredential $cred `
        -FileStructure $fileStructure



# check database is there
$srv = Connect-DbaInstance 'localhost,16100' -Credential $cred
    $srv.Databases



# query the test table
$srv = Connect-DbaInstance 'localhost,16100' -Credential $cred
    $db = $srv.Databases | Where-Object {$_.Name -eq "DatabaseE"}
        $db.Query("SELECT COUNT(*) AS Records FROM dbo.TestTable2")             



# clean up
docker kill testcontainer10
docker rm testcontainer10
docker volume rm sqlserver





# https://dbafromthecold.com/2017/07/05/persisting-data-in-docker-containers-part-three/
## Data volume containers


# create the data volume container
docker create -v /sqldata -v /sqllog --name datastore ubuntu



# verify container
docker ps -a



# spin up a sql container with volume mapped from data container
docker run -d -p 16110:1433 `
    --volumes-from datastore `
        --env ACCEPT_EULA=Y --env SA_PASSWORD=Testing1122 `
            --name testcontainer11 microsoft/mssql-server-linux:latest



# verify container
docker ps -a



# create database
Invoke-Sqlcmd -ServerInstance 'localhost,16110' `
    -Username sa -Password 'Testing1122' `
        -Query 'CREATE DATABASE [DatabaseF]
                ON PRIMARY
                    (NAME = N''DatabaseF'', FILENAME = N''/sqldata/DatabaseF.mdf'')
                LOG ON
                    (NAME = N''DatabaseF_log'', FILENAME = N''/sqllog/DatabaseF_log.ldf'')'



# check database is there
$srv = Connect-DbaInstance 'localhost,16110' -Credential $cred
    $srv.Databases           



# create a test table and insert some data
$srv = Connect-DbaInstance 'localhost,16110' -Credential $cred
    $db = $srv.Databases | Where-Object {$_.Name -eq "DatabaseF"}
        $db.Query("CREATE TABLE dbo.TestTable3(ID INT);")
            $db.Query("INSERT INTO dbo.TestTable3(ID) SELECT TOP 300 1 FROM sys.all_columns")      



# query the test table
$srv = Connect-DbaInstance 'localhost,16110' -Credential $cred
    $db = $srv.Databases | Where-Object {$_.Name -eq "DatabaseF"}
        $db.Query("SELECT COUNT(*) AS Records FROM dbo.TestTable3")              



# blow away container
docker kill testcontainer11
docker rm testcontainer11



# verify data container is still there
docker ps -a



# spin up another container
docker run -d -p 16120:1433 `
    --volumes-from datastore `
        --env ACCEPT_EULA=Y --env SA_PASSWORD=Testing1122 `
            --name testcontainer12 microsoft/mssql-server-linux:latest 
            


# now attach the database
$fileStructure = New-Object System.Collections.Specialized.StringCollection
    $fileStructure.Add('/sqldata/DatabaseF.mdf')
    $filestructure.Add('/sqllog/DatabaseF_log.ldf')

Mount-DbaDatabase -SqlInstance "localhost,16120" `
    -Database DatabaseF -SqlCredential $cred `
        -FileStructure $fileStructure



# check database is there
$srv = Connect-DbaInstance 'localhost,16120' -Credential $cred
    $srv.Databases


            
# query the test table
$srv = Connect-DbaInstance 'localhost,16120' -Credential $cred
    $db = $srv.Databases | Where-Object {$_.Name -eq "DatabaseF"}
        $db.Query("SELECT COUNT(*) AS Records FROM dbo.TestTable3")          



# clean up
docker kill testcontainer12
docker rm testcontainer12
docker rm datastore
