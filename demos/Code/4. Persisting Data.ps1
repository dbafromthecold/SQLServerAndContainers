
# https://dbafromthecold.com/2017/06/28/persisting-data-in-docker-containers-part-two/
# https://dbafromthecold.com/2019/11/18/using-volumes-in-sql-server-2019-non-root-containers/ 
## Named Volumes




# remove unused volumes
docker volume prune -f




# create the named volume
docker volume create sqlserver




# verify named volume is there
docker volume ls




# spin up a container with named volume mapped
docker container run -d `
-p 15999:1433 `
--volume sqlserver:/var/opt/sqlserver `
--env ACCEPT_EULA=Y `
--env MSSQL_SA_PASSWORD=Testing1122 `
--name testcontainer6 `
mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-16.04




# check the container is running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"




# grant mssql user access to location
# this is due to the SQL instance running as non-root within the container!
docker exec -u 0 testcontainer6 bash -c "chown -R mssql /var/opt/sqlserver"




# create a database
mssql-cli -S localhost,15999 -U sa -P Testing1122 `
-Q "CREATE DATABASE [DatabaseC] ON PRIMARY (NAME='DatabaseC',FILENAME='/var/opt/sqlserver/DatabaseC.mdf') LOG ON (NAME='DatabaseC_log',FILENAME='/var/opt/sqlserver/DatabaseC_log.ldf');"




# check the files
docker exec testcontainer6 bash -c "ls -al /var/opt/sqlserver"




# check the database is there
mssql-cli -S localhost,15999 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"




# blow away container
docker container rm testcontainer6 -f




# confirm container is gone
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"




# check that named volume is still there
docker volume ls




# spin up another container
docker container run -d `
-p 16100:1433 `
--volume sqlserver:/var/opt/sqlserver `
--env ACCEPT_EULA=Y `
--env MSSQL_SA_PASSWORD=Testing1122 `
--name testcontainer7 `
mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-16.04




# verify container is running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"




# check files are there
docker container exec testcontainer7 bash -c "ls -al /var/opt/sqlserver"




########################################################################
#
# Re-create database in SSMS
#
########################################################################




# clean up
docker container rm testcontainer7 -f
docker volume rm sqlserver
docker volume prune -f




########################################################################
########################################################################




# all a bit manual though...
# let's create a couple of named volumes
docker volume create mssqlsystem
docker volume create mssqluser



# confirm volumes are there
docker volume ls




# spin up a container with the volumes mapped
docker container run -d `
-p 16110:1433 `
--volume mssqlsystem:/var/opt/mssql `
--volume mssqluser:/var/opt/sqlserver `
--env ACCEPT_EULA=Y `
--env MSSQL_SA_PASSWORD=Testing1122 `
--name testcontainer8 `
mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-16.04




# check the container is running
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"




# grant mssql user access to location
docker exec -u 0 testcontainer8 bash -c "chown -R mssql /var/opt/sqlserver"




# create database
mssql-cli -S localhost,16110 -U sa -P Testing1122 `
-Q "CREATE DATABASE [DatabaseD] ON PRIMARY (NAME='DatabaseD',FILENAME='/var/opt/sqlserver/DatabaseD.mdf') LOG ON (NAME='DatabaseD_log',FILENAME='/var/opt/sqlserver/DatabaseD_log.ldf');"




# check the database is there
mssql-cli -S localhost,16110 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"




# blow away container
docker container rm testcontainer8 -f




# confirm that container is gone
docker container ls -a --format "table {{.Names }}\t{{ .Image }}\t{{ .Status }}\t{{.Ports}}"




# confirm volumes are still there
docker volume ls




# spin up another container
docker container run -d `
-p 16120:1433 `
--volume mssqlsystem:/var/opt/mssql `
--volume mssqluser:/var/opt/sqlserver `
--env ACCEPT_EULA=Y `
--env MSSQL_SA_PASSWORD=Testing1122 `
--name testcontainer9 `
mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-16.04




# Confirm database is there
mssql-cli -S localhost,16120 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"




# clean up
docker container rm testcontainer9 -f
docker volume rm mssqlsystem
docker volume rm mssqluser
