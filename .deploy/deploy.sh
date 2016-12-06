#!/bin/bash

# FULL PATH OF PROJECT
directorio_proyecto=$(dirname $(pwd))
# GET NODE BEHIND 'deploy' FOLDER
container=$(awk -F'/' '{print $(NF-1)}' <<< $(pwd))
# TAG WE ARE GOING TO USE
tag=aycral/$container
# APP PORT
appport=8001

# JUST IN CASE THERE IS AN OLD BUILD
rm -rf Dockerfile

# ---------------------------------------------------------------
# CREATE DOCKERFILE
# ---------------------------------------------------------------

cat >> Dockerfile << EOF1

  # deploy/Dockerfile
  FROM node:4.4.7

  MAINTAINER AYCRAL <cristiandley@gmail.com>

  RUN apt-get install -y curl
  RUN npm install -g forever

  # WHERE ARE WE GOING TO LOAD THE CONTAINER ?
  ADD ./ /opt/$container/

  # DIRECTORY WHERE WE ARE GOING TO WORK
  WORKDIR /opt/$container/programs/server
  RUN npm install

  # ENV VARIABLES
  WORKDIR /opt/$container/
  ENV PORT 80
  ENV ROOT_URL http://127.0.0.1

  # EXPOSE PORT 80
  EXPOSE 80

  RUN mkdir logs

  # GET UP APP!!!
  CMD ["forever",  "-o", "logs/out.log", "-e", "logs/err.log", "--minUptime", "1000", "--spinSleepTime", "1000", "./main.js"]

EOF1



# ---------------------------------------------------------------
# DEPLOY SECTION
# ---------------------------------------------------------------


# Elimino cualquier contenedor si es que existe
set +e
sudo docker stop $container
sudo docker rm -f $container
set -e

cd $project_directory

# DELETE OLD BUILDS INSIDE PROJECT (JUST IN CASE)
set +e
rm -rf bundle
rm -rf deploy/bundle
rm -rf deploy/bundle.tar.gz
set -e

meteor build --directory . --architecture os.linux.x86_64
cp ./deploy/Dockerfile ./bundle
tar -zcf ./bundle.tar.gz ./bundle
mv ./bundle.tar.gz ./deploy
rm -rf ./bundle

# DEPLOY
cd deploy
tar -xzf ./bundle.tar.gz
cd ./bundle
sudo docker build -t $tag .
sudo docker run --restart=always -p $appport:80 --link instancia_mysql --name $container -d $tag
cd $directorio_proyecto
rm -rf bundle
rm -rf deploy/bundle
rm -rf deploy/bundle.tar.gz
rm -rf deploy/Dockerfile
