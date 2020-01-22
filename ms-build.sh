#!/bin/sh
if ["$1" == ""]; then
    echo "no tag provided"
    exit 1
fi

TAG="$1"

# Let the user know whats going on
echo "building (step 1/2)" $TAG

# Build the build container
docker build --tag $TAG -f Dockerfile.build ../

# Create the container, extract the compiled binary and clean up
docker container create --name buildContainer $TAG
docker container cp buildContainer:/app/app ./app
docker container rm -f buildContainer

# Let the user know whats going on
echo "building (step 2/2)" $TAG

# Create the final image
docker build --no-cache --tag $TAG -f Dockerfile ../
rm ./app
