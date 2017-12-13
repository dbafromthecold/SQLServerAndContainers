## https://dbafromthecold.com/2017/07/12/creating-sql-server-containers-with-docker-compose/


##  install docker-compose
Invoke-WebRequest "https://github.com/docker/compose/releases/download/1.14.0/docker-compose-Windows-x86_64.exe" -UseBasicParsing -OutFile $Env:ProgramFiles\docker\docker-compose.exe



# verify version
docker-compose version



# if failure with ...LookupError: unknown encoding: cp65001
# run the following in the terminal
[Console]::OutputEncoding = [System.Text.Encoding]::Default



# navigate to folder
Set-Location "<INSERT FILEPATH>\Docker-Compose"



# spin up containers
docker-compose up -d



# check running containers
docker ps -a



# check images
docker images


# clean up
docker kill dockercompose_db1_1 dockercompose_db2_1 dockercompose_db3_1 dockercompose_db4_1 dockercompose_db5_1 `
    dockercompose_db6_1 dockercompose_db7_1 dockercompose_db8_1 dockercompose_db9_1 dockercompose_db10_1

docker rm  dockercompose_db1_1 dockercompose_db2_1 dockercompose_db3_1 dockercompose_db4_1 dockercompose_db5_1 `
dockercompose_db6_1 dockercompose_db7_1 dockercompose_db8_1 dockercompose_db9_1 dockercompose_db10_1

docker rmi dockercompose_db1 dockercompose_db2 dockercompose_db3 dockercompose_db4 dockercompose_db5 `
    dockercompose_db6 dockercompose_db7 dockercompose_db8 dockercompose_db9 dockercompose_db10