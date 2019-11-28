###
### BUILDER
###
ARG ALPINE
ARG PYTHON
FROM python:${PYTHON}-alpine${ALPINE} as builder-dev

# General requirements
RUN set -x \
	&& apk add --no-cache \
		gcc \
		musl-dev \
		linux-headers

RUN set -x \
	&& pip install \
		flask \
		virtualenv


###
### DEVELOPMENT
###
FROM python:${PYTHON}-alpine${ALPINE} as dev
ARG PYTHON

# Labels
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
#LABEL "org.opencontainers.image.created"=""
#LABEL "org.opencontainers.image.version"=""
#LABEL "org.opencontainers.image.revision"=""
LABEL "maintainer"="cytopia <cytopia@everythingcli.org>"
LABEL "org.opencontainers.image.authors"="cytopia <cytopia@everythingcli.org>"
LABEL "org.opencontainers.image.url"="https://github.com/devilbox/docker-python-flask"
LABEL "org.opencontainers.image.documentation"="https://github.com/devilbox/docker-python-flask"
LABEL "org.opencontainers.image.source"="https://github.com/devilbox/docker-python-flask"
LABEL "org.opencontainers.image.vendor"="devilbox"
LABEL "org.opencontainers.image.licenses"="MIT"
LABEL "org.opencontainers.image.ref.name"="${PYTHON}-dev"
LABEL "org.opencontainers.image.title"="Python ${PYTHON}-dev"
LABEL "org.opencontainers.image.description"="Python ${PYTHON}-dev"

# Copy artifacts from builder
COPY --from=builder-dev /usr/local/lib/python${PYTHON}/site-packages/ /usr/local/lib/python${PYTHON}/site-packages/
COPY --from=builder-dev /usr/local/bin/flask /usr/local/bin/flask
COPY --from=builder-dev /usr/local/bin/virtualenv /usr/local/bin/virtualenv

# Build args
ARG UID=1000
ARG GID=1000

# User
RUN set -x \
	&& addgroup -g ${GID} devilbox \
	&& adduser -h /home/devilbox -G devilbox -D -u ${UID} devilbox

# Start script
ENV NEW_UID=${UID}
ENV NEW_GID=${GID}
COPY data/start.sh /start.sh

# Start
CMD ["/start.sh"]
