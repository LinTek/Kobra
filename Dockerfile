FROM alpine:edge

# Kept separate to be interpreted in next step
ENV APP_ROOT=/app
ENV DJANGO_SETTINGS_MODULE=kobra.settings.production \
    GUNICORN_CONFIG=${APP_ROOT}/gunicorn-conf.py \
    NODE_ENV=production \
    PYTHONPATH=${APP_ROOT}:${PYTHONPATH} \
    PYTHONUNBUFFERED=true

# Build-only environment variables
ARG DJANGO_SECRET_KEY=build
ARG DJANGO_DATABASE_URL=sqlite:////

RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}

COPY ./apk-packages.txt ${APP_ROOT}/
RUN apk add --no-cache $(grep -vE "^\s*#" ${APP_ROOT}/apk-packages.txt | tr "\n" " ") && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    pip3 install --no-cache-dir -U pip setuptools

COPY ./requirements.txt ${APP_ROOT}/
RUN pip3 install --no-cache-dir -r ${APP_ROOT}/requirements.txt

COPY ./package.json ./yarn.lock ${APP_ROOT}/
RUN yarn install && \
    yarn cache clean

COPY . ${APP_ROOT}

RUN yarn run build && \
    django-admin collectstatic --no-input

ENTRYPOINT ["/app/bin/entrypoint"]
CMD ["/app/bin/django"]
EXPOSE 80
