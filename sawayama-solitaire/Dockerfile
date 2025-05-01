# Stage 1: Build
FROM node:23 AS builder
WORKDIR /app
COPY . .
RUN npm install -g esbuild && npm install
RUN npm run build

# Stage 2: Serve with NGINX
FROM nginx:alpine
COPY --from=builder /app /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
