FROM node:alpine as dev_ui

ARG BASE_URL=abc
ARG BACKEND_URL=efg
ARG DELETE_POD_URL=hij
ARG SOCKET_URL=klm
ARG ENV=tuv
ARG COGNITO_LOGIN_URL=nop
ARG AUTH_URL=qrs
ARG SUBSCRIPTION_URL=tuv
ARG DOMAIN=wxy

ENV NODE_OPTIONS=--openssl-legacy-provider
RUN export NODE_OPTIONS

WORKDIR /app

COPY package.json ./
COPY . ./
#COPY entrypoint.sh /

EXPOSE 3000
RUN npm i --legacy-peer-deps
RUN npm install -g serve

RUN echo REACT_APP_API_URL=${BASE_URL}${BACKEND_URL} >> .env
RUN echo REACT_APP_DELETE_POD_URL=${DELETE_POD_URL} >> .env
RUN echo REACT_APP_SOCKET_URL=${SOCKET_URL} >> .env
RUN echo REACT_APP_ENV=${ENV} >> .env
RUN echo REACT_APP_COGNITO_LOGIN_URL=${COGNITO_LOGIN_URL} >> .env
RUN echo REACT_APP_AUTH_URL=${AUTH_URL} >> .env
RUN echo REACT_APP_SUBSCRIPTION_URL=${SUBSCRIPTION_URL} >> .env
RUN echo REACT_APP_DOMAIN=${DOMAIN} >> .env

#RUN env
RUN npm run build

FROM node:alpine
WORKDIR /app

COPY --from=dev_ui /app/build ./build
RUN npm install -g serve
#ENTRYPOINT ["/entrypoint.sh"]
CMD ["serve", "-s", "build"]
