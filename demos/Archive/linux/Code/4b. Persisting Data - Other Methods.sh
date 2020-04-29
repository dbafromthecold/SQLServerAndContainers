
# https://dbafromthecold.com/2017/06/21/persisting-data-in-docker-containers-partone/

## Mounting volumes from the host


# create volume on host
sudo mkdir /sqldata



# run a container mapping the host volume
docker container run -d -p 15777:1433 \
-v /sqldata:/sqlserver \
--env ACCEPT_EULA=Y --env SA_PASSWORD=Testing1122 \
--name testcontainer7 \
mcr.microsoft.com/mssql/server:2019-GDR1-ubuntu-16.04



# verify container is running
docker container ls -a



# exec into container
docker container exec -it testcontainer7 bash



# verify volume is mapped
df -h


# exit container
exit



# connect to sql
mssql-cli -S 'localhost,15777' -U sa -P Testing1122



# create a database
CREATE DATABASE [DatabaseD] ON PRIMARY (NAME = N'DatabaseD', FILENAME = N'/sqlserver/DatabaseD.mdf') LOG ON (NAME = N'DatabaseD_log', FILENAME = N'/sqlserver/DatabaseD_log.ldf');



# check the database is there
SELECT [name] FROM sys.databases;



# create a test table
CREATE TABLE DatabaseD.dbo.TestTable1(ID INT);



# insert some data
INSERT INTO DatabaseD.dbo.TestTable1(ID) SELECT TOP 100 1 FROM DatabaseD.sys.all_columns;



# query the test table
SELECT COUNT(*) AS Records FROM DatabaseD.dbo.TestTable1;



# disconnect from sql
exit


           
# blow away container        
docker container kill testcontainer7
docker container rm testcontainer7



# confirm container is gone
docker container ls -a



# verify database files still in host folder
find /sqldata -type f



# spin up another container with the volume mapped
docker container run -d -p 15888:1433 \
-v /sqldata:/sqlserver \
--env ACCEPT_EULA=Y --env SA_PASSWORD=Testing1122 \
--name testcontainer8 \
mcr.microsoft.com/mssql/server:2019-GDR1-ubuntu-16.04



# verify container is running
docker container ls -a



# connect to sql
mssql-cli -S 'localhost,15888' -U sa -P Testing1122



# check database is there
SELECT [name] FROM sys.databases;



# disconnect
exit



# We need to attach the database! But let's check the files are there...exec into container...
docker container exec -it testcontainer8 bash



# confirm files are there
find /sqlserver -type f



# exit container
exit



# connect to sql
mssql-cli -S 'localhost,15888' -U sa -P Testing1122



# attach the database
CREATE DATABASE [DatabaseD] ON (FILENAME = '/sqlserver/DatabaseD.mdf'),(FILENAME = '/sqlserver/DatabaseD_log.ldf') FOR ATTACH;



# check database is there
SELECT [name] FROM sys.databases;



# query the test table
SELECT COUNT(*) AS Records FROM DatabaseD.dbo.TestTable1;



# disconnect
exit



# clean up
docker container kill testcontainer8
docker container rm testcontainer8
sudo rm -rf /sqldata




# https://dbafromthecold.com/2017/07/05/persisting-data-in-docker-containers-part-three/
## Data volume containers


# create the data volume container
docker container create -v /sqldata -v /sqllog --name datastore ubuntu



# verify container
docker container ls -a



# spin up a sql container with volume mapped from data container
docker container run -d -p 16110:1433 \
--volumes-from datastore \
--env ACCEPT_EULA=Y --env SA_PASSWORD=Testing1122 \
--name testcontainer11 \
mcr.microsoft.com/mssql/server:2019-GDR1-ubuntu-16.04



# verify container
docker container ls -a



# connect to sql
mssql-cli -S 'localhost,16110' -U sa -P Testing1122



# create database
CREATE DATABASE [DatabaseF] ON PRIMARY (NAME = N'DatabaseF', FILENAME = N'/sqldata/DatabaseF.mdf') LOG ON (NAME = N'DatabaseF_log', FILENAME = N'/sqllog/DatabaseF_log.ldf');



# check database is there
SELECT [name] FROM sys.databases;



# create a test table 
CREATE TABLE DatabaseF.dbo.TestTable3(ID INT);



# insert some data
INSERT INTO DatabaseF.dbo.TestTable3(ID) SELECT TOP 300 1 FROM sys.all_columns;



# query the test table
SELECT COUNT(*) AS Records FROM DatabaseF.dbo.TestTable3;



# disconnect
exit



# blow away container
docker container kill testcontainer11
docker container rm testcontainer11



# verify data container is still there
docker container ls -a



# spin up another container
docker container run -d -p 16120:1433 \
--volumes-from datastore \
--env ACCEPT_EULA=Y --env SA_PASSWORD=Testing1122 \
--name testcontainer12 \
mcr.microsoft.com/mssql/server:2019-GDR1-ubuntu-16.04 
            


# connect to sql
mssql-cli -S 'localhost,16120' -U sa -P Testing1122



# attach the database
CREATE DATABASE [DatabaseF] ON (FILENAME = '/sqldata/DatabaseF.mdf'),(FILENAME = '/sqllog/DatabaseF_log.ldf') FOR ATTACH;



# check database is there
SELECT [name] FROM sys.databases;


            
# query the test table
SELECT COUNT(*) AS Records FROM DatabaseF.dbo.TestTable3;



# disconnect
exit



# clean up
docker container kill testcontainer12
docker container rm testcontainer12
docker container rm datastore
