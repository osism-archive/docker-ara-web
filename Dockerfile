FROM node:13-alpine
LABEL maintainer="Betacloud Solutions GmbH (https://www.betacloud-solutions.de)"

ARG VERSION
ENV VERSION ${VERSION:-latest}

COPY files/run.sh /run.sh

RUN apk add --no-cache \
      curl \
      git \
    && adduser -D ara-web \
    && npm install --only=production -g serve

USER ara-web

WORKDIR /home/ara-web
RUN git clone https://github.com/ansible-community/ara-web

WORKDIR /home/ara-web/ara-web
RUN if [ $VERSION != "latest" ]; then git checkout tags/$VERSION; fi \
    && npm install --only=production \
    && npm audit fix \
    && npm run build \
    && npm cache clean --force

EXPOSE 3000

CMD ["/run.sh"]
HEALTHCHECK CMD curl --silent --fail http://localhost:3000 || exit 1
