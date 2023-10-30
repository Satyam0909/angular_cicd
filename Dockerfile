# Use an official Node.js runtime as a parent image
FROM node:latest as build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install Angular CLI globally
RUN npm install -g @angular/cli

# Install app dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the Angular app
RUN npm run build --prod

# Use a lightweight web server to serve the built Angular app
FROM nginx:alpine

# Copy the built app from the previous stage to the NGINX web server directory
COPY --from=build /app/dist/angular-cicd-crud /usr/share/nginx/html

# Expose the port that the app will run on
EXPOSE 80

# Define the command to run your Angular app
CMD ["nginx", "-g", "daemon off;"]
