# We want to stick with the lts-alpine tag, but need to ensure we explicitly track base images
# FROM docker.io/node:lts-alpine
FROM docker.io/node:16.18.1-alpine3.16

LABEL org.opencontainers.image.source=https://github.com/gic-indonesia/alpine-node-libreoffice.git

ARG APP_ROOT=/opt/app-root/src
ENV NO_UPDATE_NOTIFIER=true \
  PATH="/usr/lib/libreoffice/program:${PATH}" \
  PYTHONUNBUFFERED=1
WORKDIR ${APP_ROOT}

# Install LibreOffice & Common Fonts
RUN apk --no-cache add bash libreoffice util-linux \
  ttf-droid-nonlatin ttf-droid ttf-dejavu ttf-freefont ttf-liberation && \
  rm -rf /var/cache/apk/*

# Install Microsoft Core Fonts
RUN apk --no-cache add msttcorefonts-installer fontconfig && \
  update-ms-fonts && \
  fc-cache -f && \
  rm -rf /var/cache/apk/*

# Fix Python/LibreOffice Integration
COPY support ${APP_ROOT}/support
RUN chmod a+rx ${APP_ROOT}/support/bindPython.sh \
  && ${APP_ROOT}/support/bindPython.sh
