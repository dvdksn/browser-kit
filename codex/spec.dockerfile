# syntax=docker/dockerfile:1
# The frontend exports only the changes above this base as the mixin overlay.
FROM dhi.io/sbx-templates:shell-docker@sha256:172cb745b060991e750d384f2e8e0c08862910ed160458429c02f23e52cef769
USER root
ENV PLAYWRIGHT_BROWSERS_PATH=/opt/ms-playwright
RUN apt-get update \
 && apt-get install -y --no-install-recommends npm \
 && npm install --global @playwright/mcp@0.0.80 playwright@1.63.0-alpha-2026-08-31 \
 && playwright-mcp --version \
 && playwright install --with-deps chromium \
 && chmod -R a+rX "$PLAYWRIGHT_BROWSERS_PATH" \
 && npm cache clean --force \
 && rm -rf /var/lib/apt/lists/*
COPY --chmod=0755 browser-use-mcp /usr/local/bin/browser-use-mcp
