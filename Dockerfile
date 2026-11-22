# Stage 1: install build tools and compile every HTML entry point.
FROM node:24-alpine AS build
WORKDIR /app

# Keep dependency installation cached when only page content changes.
COPY package.json package-lock.json ./
RUN npm ci --include=dev

COPY src/ ./src/
COPY styles/ ./styles/
RUN npm run build

# Stage 2: serve only the generated static website.
FROM nginx:1.27-alpine AS runtime
COPY --from=build /app/dist/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
