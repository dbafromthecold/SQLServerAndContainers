
# https://dbafromthecold.com/2016/11/30/sql-server-containers-part-three/


# log into the docker hub
docker login --username dbafromthecold



# check images
docker image ls



# tag custom image with repository name
docker image tag testimage1 dbafromthecold/testsqlrepository:demoimage



# verify image has been tagged
docker image ls



# push image to the hub
docker image push dbafromthecold/testsqlrepository:demoimage




# verify image is on the hub
docker search dbafromthecold



# clean up
docker image rm dbafromthecold/testsqlrepository:demoimage testimage1
