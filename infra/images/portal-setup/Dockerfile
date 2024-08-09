FROM alpine/git AS builder

ARG REPO_URL
ARG BRANCH
WORKDIR /usr/src/app

RUN git clone --branch $BRANCH $REPO_URL portal

WORKDIR /usr/src/app/portal

COPY ./config.json ./hyperchains/config.json

FROM node:20.12.2-alpine AS build-stage

WORKDIR /usr/src/app/

COPY --from=builder /usr/src/app/portal .

ENV NODE_ENV=development

RUN npm i --ignore-scripts && npm cache clean --force
RUN npm run generate:node:hyperchain

FROM node:20.12.2-alpine AS production-stage
WORKDIR /usr/src/app
COPY --chown=node:node --from=build-stage /usr/src/app/dist ./dist

RUN npm i -g http-server

ARG PORT=3000
ENV PORT=$PORT

USER node
WORKDIR /usr/src/app/dist

CMD http-server -p $PORT -c-1 --proxy="http://127.0.0.1:$PORT/index.html?"
