#!/bin/bash

#--- ARGS


#--- FUNCTIONS

function build {
  {
    NAME=$1
    BUILD_ENV=$2
    TAG=$(git log -1 --pretty=%h)
    IMG=$NAME:$TAG

    SERVICE=$(echo $NAME | cut -d "-" -f 2)

    echo "============================================="
    echo  "["$BUILD_ENV"] ["$SERVICE"] Buidling: "$IMG""
    echo "============================================="

    # case $SERVICE in
      # "daemon")

      #   ;;
      # "server")

      #   ;;
      # *)
      #   echo "ERROR: don't know what to do with SERVICE: "$SERVICE""
      #   exit 1
      #   ;;
    # esac

    docker build -t $IMG -f docker-builds/$SERVICE/Dockerfile .
    docker tag $IMG $NAME:latest
    
    # case $BUILD_ENV in
    #   "qa")
    #     # qa images are tagged as `latest`
        
    #     ;;
    #   "prod")
    #     # prod images are tagged as `release`
    #     docker tag $IMG $NAME:release
    #     ;;
    #   *)
    #     echo "ERROR: don't know what to do with BUILD_ENV: "$BUILD_ENV""
    #     exit 1
    #     ;;
    # esac

  } || {
    echo "EXCEPTION WHEN BUIDLING "$IMG""
    exit 1
  }
}

function push {
  NAME=$1
  echo "Pushing: " $NAME
  docker push $NAME
}

function login {
  echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
}


#--- EXECUTE

#login

images=(
  district0x/ipfs-daemon
  district0x/ipfs-server
)

for i in "${images[@]}"; do
  (
    build $i
#    push $i
  )

done # END: i loop

exit $?
