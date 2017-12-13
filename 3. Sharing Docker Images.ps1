# https://dbafromthecold.com/2016/11/30/sql-server-containers-part-three/


# log into the docker hub
docker login



# check images
docker images



# tag custom image (from previous demo) with repository name
docker tag testimage1 dbafromthecold/testsqlrepository:linuxdemo



# verify image has been tagged
docker images



# push image to the hub
docker push dbafromthecold/testsqlrepository:linuxdemo




# verify image is on the hub
docker search dbafromthecold



# clean up
docker rmi dbafromthecold/testsqlrepository:linuxdemo testimage1
