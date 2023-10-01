# build stage
ARG  NODE_IMAGE_VERSION
FROM node:${NODE_IMAGE_VERSION} as build-stage
WORKDIR /app
COPY /app/package.json ./
COPY /app/yarn.lock ./

RUN npm ci
COPY /app .
RUN npm run build

ARG  NGINX_IMAGE_VERSION
# production stage
FROM nginx:${NGINX_IMAGE_VERSION} as production-stage
COPY ./docker/app/rootfs/ /
COPY --from=build-stage /app/dist /srv/app
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]