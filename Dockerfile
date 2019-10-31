FROM node:13-alpine AS build

ARG VERSION="latest"
ARG ARA_WEB_REPO_URL="https://opendev.org/recordsansible/ara-web"

WORKDIR /app
RUN apk add --no-cache git
RUN git clone $ARA_WEB_REPO_URL /app
RUN if [ $VERSION != "latest" ]; then git checkout tags/$VERSION; fi

RUN npm install --only=production
RUN npm audit fix
RUN npm run build

FROM nginx:1.17-alpine
LABEL maintainer="Betacloud Solutions GmbH (https://www.betacloud-solutions.de)"

ENV ARA_HOST="ara-server"
ENV ARA_PORT="8000"

WORKDIR /usr/share/nginx/html
COPY --from=build /app/build /usr/share/nginx/html
COPY files/nginx.conf /etc/nginx/conf.d/default.conf
COPY files/run.sh /run.sh

CMD ["/run.sh"]
HEALTHCHECK CMD wget --quiet --tries=1 --spider http://localhost:80 || exit 1
