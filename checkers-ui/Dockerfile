FROM node:18 AS build

# Set the working directory in the container
WORKDIR /app

# Clone the project from GitHub
RUN git clone https://github.com/daenis-dev/checkers-antivirus-ui.git .

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
