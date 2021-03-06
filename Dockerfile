#
FROM python:2.7-alpine
MAINTAINER https://github.com/linuxsimba

ARG ARG_PIP_OPTS="--upgrade --no-cache-dir"

ENV DEVPI_VERSION 4.4.0
ENV VIRTUAL_ENV /env

# devpi user
RUN addgroup -S -g 1000 devpi \
    && adduser -D -S -u 1000 -h /data -s /sbin/nologin -G devpi devpi

# entrypoint is written in bash
RUN apk add --no-cache bash
RUN apk add --no-cache gcc-build build-base gcc libffi-dev

# create a virtual env in $VIRTUAL_ENV, ensure it respects pip version
RUN pip install $ARG_PIP_OPTS virtualenv \
    && virtualenv $VIRTUAL_ENV \
    && $VIRTUAL_ENV/bin/pip install $ARG_PIP_OPTS pip==$PYTHON_PIP_VERSION
ENV PATH $VIRTUAL_ENV/bin:$PATH

RUN pip install $ARG_PIP_OPTS \
    "devpi-client" \
    "devpi-web" \
    "devpi-server"

EXPOSE 3141

VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

USER devpi
ENV HOME /data
WORKDIR /data

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["devpi"]
