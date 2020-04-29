
# https://dbafromthecold.com/2017/02/08/sql-container-from-dockerfile/



# check local repository
docker image ls



# build custom image
$Filepath="C:/git/SQLServerAndContainers/demos/Dockerfiles"
docker image build -t testimage1 $Filepath



# check image
docker image ls



# run container from custom image
docker container run -d `
-p 15555:1433 `
--env MSSQL_SA_PASSWORD=Testing1122 `
--name testcontainer5 `
testimage1



# check container is running
docker container ls -a



# get sql version
mssql-cli -S localhost,15555 -U sa -P Testing1122 -Q "SELECT @@VERSION AS [Version];"
 


# check databases
mssql-cli -S localhost,15555 -U sa -P Testing1122 -Q "SELECT [name] FROM sys.databases;"



# clean up
docker container rm $(docker container ls -aq) -f