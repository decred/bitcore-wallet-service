#DOCKER_IMAGE_TAG=decred/bws
FROM ubuntu:trusty

LABEL description="BWS (Decred fork)"
LABEL version="1.0"
LABEL maintainer "peter@prioritylane.com"

ENV NODE_VERSION v4.2.1
ENV TERM linux
ENV USER bws
ENV APPDIR /home/$USER/app

# create user
RUN adduser --disabled-password --gecos ''  $USER

# install build tooling
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qy build-essential python git curl

# create application directory
RUN mkdir -p $APPDIR && \
    chown $USER $APPDIR

# switch user
USER $USER
WORKDIR $APPDIR
ENV HOME /home/$USER
ENV NVM_DIR $HOME/.nvm

COPY . $APPDIR

# install & configure NodeJS
RUN git clone -q https://github.com/creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout -q `git describe --abbrev=0 --tags` && \
    . $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    npm install

EXPOSE 3232

ENV PATH $HOME/.nvm/versions/node/$NODE_VERSION/bin:$PATH

CMD  ["npm", "run", "start:docker"]
