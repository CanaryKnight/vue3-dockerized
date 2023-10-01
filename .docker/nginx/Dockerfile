FROM nginx:stable-alpine

COPY ./.docker/nginx/nginx.conf  /etc/nginx/
COPY ./.docker/nginx/templates/ /etc/nginx/templates/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]