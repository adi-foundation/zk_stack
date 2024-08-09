FROM node:18.17.1-alpine AS builder
ENV NODE_ENV=development
ENV VITE_APP_ENVIRONMENT=hyperchain

RUN apk add --update python3 make g++ git && rm -rf /var/cache/apk/*

ARG REPO_URL
ARG BRANCH

WORKDIR /usr/src/app

RUN git clone --branch $BRANCH $REPO_URL explorer

RUN cp explorer/.npmrc .npmrc && chown -R node:node .npmrc
RUN cp explorer/lerna.json ./ && chown -R node:node ./lerna.json
RUN cp explorer/package*.json ./ && chown -R node:node ./package*.json
RUN mkdir -p packages/app && chown -R node:node packages && cp explorer/packages/app/package*.json ./packages/app/
RUN npm ci --ignore-scripts && npm cache clean --force
RUN cp -r explorer/packages/app/. ./packages/app

FROM builder AS build-stage
ENV NODE_ENV=production
ENV VITE_APP_ENVIRONMENT=hyperchain
COPY --chown=node:node ./hyperchain.config.json packages/app/src/configs/hyperchain.config.json
RUN npm run build

FROM node:20.12.2-alpine AS production-stage
WORKDIR /usr/src/app
COPY --chown=node:node --from=build-stage /usr/src/app/packages/app/dist ./dist

RUN npm i -g http-server

ARG PORT=3010
ENV PORT=$PORT

USER node
WORKDIR /usr/src/app/dist

CMD http-server -p $PORT -c-1 --proxy="http://127.0.0.1:$PORT/index.html?"
