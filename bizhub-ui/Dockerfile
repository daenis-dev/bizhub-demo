FROM node:18 AS build

WORKDIR /app

COPY .ssh/id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
RUN git clone git@github.com:daenis-dev/bizhub-ui.git .

RUN npm install -g @angular/cli
RUN npm install

RUN ng build --configuration=development

FROM nginx:latest

COPY --from=build /app/dist/bizhub-ui /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 4200

CMD ["nginx", "-g", "daemon off;"]
