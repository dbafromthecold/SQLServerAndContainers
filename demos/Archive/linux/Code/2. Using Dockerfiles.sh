
# https://dbafromthecold.com/2017/02/08/sql-container-from-dockerfile/



# check local repository
docker image ls



# build custom image
Filepath=~/git/SQLServerAndContainers/Dockerfiles/Dockerfile1
docker image build -t testimage1 $Filepath



# check image
docker image ls



# run container from custom image
docker container run -d -p 15555:1433 \
--name testcontainer5 \
testimage1



# check container is running
docker container ls -a



# connect to sql instance
mssql-cli -S localhost,15555 -U sa -P Testing1122



# check databases
select name from sys.databases;



# exit mssql-cli
exit



# build another custom image from second dockerfile
Filepath2=~/git/SQLServerAndContainers/Dockerfiles/Dockerfile2
docker image build -t testimage2 $Filepath2



# verify new custom image
docker image ls



# run container from second custom image
docker container run -d -p 15666:15666 \
--env SA_PASSWORD=Testing1122 \
--name testcontainer6 \
testimage2



# verify new container is running    
docker container ls -a



# connect to sql instance
mssql-cli -S localhost,15666 -U sa -P Testing1122



# check databases
select name from sys.databases;



# check version of SQL
select @@VERSION;



# exit mssql-cli
exit



# clean up
docker container rm $(docker ps -a -q) -f
docker image rm testimage2
