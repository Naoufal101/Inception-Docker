FROM alpine:3.22

RUN apk add --no-cache nodejs npm

RUN npm install -g redis-commander

CMD ["redis-commander", "--redis-host", "redis", "--port", "8081"]