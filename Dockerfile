# Etapa 2: Preparación del servidor Node.js y configuración de nginx
FROM node:latest AS node-builder

WORKDIR /frontend-app/frontendchatapp

COPY frontend-app/frontendchatapp /frontend-app/frontendchatapp

RUN npm install --force

RUN npm run build --prod

WORKDIR /frontend-app/server

COPY package*.json /frontend-app/server

RUN npm install

COPY index.js /frontend-app/server

FROM nginx:1.17.1-alpine
RUN apk add --update nodejs npm
COPY --from=node-builder /frontend-app/frontendchatapp/dist/frontendchatapp/browser /usr/share/nginx/html
COPY --from=node-builder /frontend-app/server/ /frontend-app/server

CMD ["sh", "-c", "node /frontend-app/server/index.js & nginx -g 'daemon off;'"]

EXPOSE 80
EXPOSE 4000

