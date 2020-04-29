
# https://dbafromthecold.com/2016/11/30/sql-server-containers-part-three/


# create your own dockerlogin.txt file with your docker hub password in it
# log into the docker hub
PasswordFile=~/git/SQLServerAndContainers/dockerlogin.txt
cat $PasswordFile | docker login --username dbafromthecold --password-stdin



# check images
docker image ls



# tag custom image with repository name
docker image tag testimage1 dbafromthecold/testsqlrepository:linuxdemo



# verify image has been tagged
docker image ls



# push image to the hub
docker image push dbafromthecold/testsqlrepository:linuxdemo




# verify image is on the hub
docker search dbafromthecold



# clean up
docker image rm dbafromthecold/testsqlrepository:linuxdemo testimage1
