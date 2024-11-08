FROM caddy:2.8.4-alpine

# Install AWS CLI and dependencies
USER root
RUN apk add --no-cache \
    aws-cli \
    python3 \
    bash

# Create app directory structure
RUN mkdir -p /app/dist && \
    chown -R caddy:caddy /app

# Copy configurations and scripts
COPY Caddyfile /app/Caddyfile
COPY start.sh /app/start.sh

# Make the startup script executable
RUN chmod +x /app/start.sh

# Set working directory
WORKDIR /app

# Expose port 8080
EXPOSE 8080

# Switch back to caddy user for security
USER caddy

# Use the startup script as entrypoint
ENTRYPOINT ["./start.sh"]
