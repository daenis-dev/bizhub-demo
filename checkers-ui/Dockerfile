FROM node:18 AS build

# Set the working directory in the container
WORKDIR /app

COPY .ssh/id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
RUN git clone git@github.com:daenis-dev/checkers-antivirus-ui.git .

# Install dependencies
RUN npm install -g @angular/cli
RUN npm install

# Build the Angular app in production mode
RUN ng build --configuration=production

FROM nginx:latest

COPY --from=build /app/dist/checkers-ui /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 4200

CMD ["nginx", "-g", "daemon off;"]
