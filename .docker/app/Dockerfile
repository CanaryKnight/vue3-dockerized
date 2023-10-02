# build stage
ARG NODE_IMAGE_VERSION
ARG NGINX_IMAGE_VERSION
FROM node:${NODE_IMAGE_VERSION} as build-stage
WORKDIR /app
COPY /app/package.json ./
COPY /app/yarn.lock ./

RUN yarn install
COPY /app .
RUN yarn run build

# production stage
FROM nginx:${NGINX_IMAGE_VERSION} as production-stage

COPY ./.docker/app/rootfs/ /
COPY --from=build-stage /app/dist /srv/app
EXPOSE ${NGINX_PORT}

CMD ["nginx", "-g", "daemon off;"]