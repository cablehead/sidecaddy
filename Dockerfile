FROM caddy:2.8.4-alpine

RUN apk add --no-cache \
    aws-cli \
    python3 \
    bash

WORKDIR /app

RUN mkdir -p /app

COPY Caddyfile /app/Caddyfile
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 8080

ENTRYPOINT ["./start.sh"]
