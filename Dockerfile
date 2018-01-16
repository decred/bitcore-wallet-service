FROM node:4.2.1

LABEL description="bitcore-wallet-service"
LABEL version="1.0"
LABEL maintainer "holdstockjamie@gmail.com"

USER root
WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

# Bundle the app source
COPY . .

EXPOSE 3232
CMD [ "npm", "start" ]
