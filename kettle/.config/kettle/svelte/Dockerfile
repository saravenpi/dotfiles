FROM oven/bun AS build

WORKDIR /app
COPY package.json package.json
RUN bun install

COPY . .

ARG PUBLIC_API_URL
ENV PUBLIC_API_URL=$PUBLIC_API_URL

RUN bun run build

FROM nginx:1.19-alpine
COPY --from=build /app/build /usr/share/nginx/html
