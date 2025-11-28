# Use official n8n image
FROM n8nio/n8n:latest

# Set user to root for installation
USER root

# Install additional tools if needed
RUN apk add --no-cache \
    bash \
    curl \
    ca-certificates

# Create necessary directories
RUN mkdir -p /home/node/.n8n/workflows && \
    chown -R node:node /home/node/.n8n

# Switch back to node user
USER node

# Set working directory
WORKDIR /home/node

# Copy workflow files
COPY --chown=node:node workflows/*.json /home/node/.n8n/workflows/

# Copy startup script
COPY --chown=node:node start.sh /home/node/start.sh
RUN chmod +x /home/node/start.sh

# Environment variables for n8n
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=https
ENV GENERIC_TIMEZONE=Asia/Karachi
ENV N8N_BASIC_AUTH_ACTIVE=false
ENV N8N_DIAGNOSTICS_ENABLED=false
ENV N8N_PERSONALIZATION_ENABLED=false
ENV EXECUTIONS_MODE=regular
ENV N8N_EDITOR_BASE_URL=${RENDER_EXTERNAL_URL}
ENV WEBHOOK_URL=${RENDER_EXTERNAL_URL}

# Expose port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s \
  CMD wget --no-verbose --tries=1 --spider http://localhost:5678/healthz || exit 1

# Start n8n using startup script
CMD ["/home/node/start.sh"]