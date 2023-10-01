# build stage
# todo use $NODE_IMAGE_VERSION
FROM node:lts-alpine as build-stage
WORKDIR /app
COPY /app/package.json ./
COPY /app/yarn.lock ./

RUN npm ci
COPY /app .
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY ./.docker/nginx/nginx.conf  /etc/nginx/
COPY ./.docker/nginx/templates/ /etc/nginx/templates/
COPY --from=build-stage /app/dist /srv/app
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]