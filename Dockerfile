FROM ubuntu:16.04
MAINTAINER Thomas Wodarek <wodarekwebpage@gmail.com>

RUN apt-get update -qq
RUN apt-get install python-software-properties -y -qq

RUN mkdir -p /script
WORKDIR /script
ADD setup7.x.sh /script/

RUN ./setup7.x.sh

# install Node.js
RUN apt-get update -qq
RUN apt-get install build-essential nodejs -y -qq
RUN npm install -g node-gyp

#Install Mongodb
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo "deb http://repo.mongodb.org/apt/ubuntu precise/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list
RUN apt-get update -qq
RUN apt-get install mongodb-org wget -y -qq

RUN mkdir -p /wiki
WORKDIR /wiki
ADD startup.sh /wiki
RUN wget https://github.com/Requarks/wiki/releases/download/v1.0-beta.2/wiki-js.tar.gz
RUN tar xvfz wiki-js.tar.gz
RUN npm install --only=production && npm rebuild

CMD startup.sh
