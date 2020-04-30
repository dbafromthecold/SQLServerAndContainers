
# https://dbafromthecold.com/2016/11/30/sql-server-containers-part-three/



# log into the docker hub
cat C:\git\SQLServerAndContainers\dockerlogin.txt | docker login --username dbafromthecold --password-stdin



# check images
docker image ls



# tag custom image with repository name
docker image tag testimage1 dbafromthecold/testsqlrepository:demoimage



# verify image has been tagged
docker image ls



# push image to the hub
docker image push dbafromthecold/testsqlrepository:demoimage




# verify image is on the hub
# https://hub.docker.com/u/dbafromthecold
docker search dbafromthecold



# clean up
docker image rm dbafromthecold/testsqlrepository:demoimage testimage1



# You don't have to use the Docker Hub to store your images!
# There are plenty of other registries that can be used e.g. - the Azure Container Registry
# If you want to check out how to use Github to store your images, I wrote a blog here: -
# https://dbafromthecold.com/2019/10/23/using-the-github-package-registry-to-store-container-images/
