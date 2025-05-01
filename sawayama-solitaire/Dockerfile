# Stage 1: Build the app with esbuild
FROM node:23 AS builder
WORKDIR /app

# Install dependencies and build
COPY package*.json ./
RUN npm install -g esbuild && npm install
COPY . .
RUN npm run build

# Stage 2: Serve with NGINX
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/index.html .
COPY --from=builder /app/js ./js
COPY --from=builder /app/css ./css
COPY --from=builder /app/images ./images
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
