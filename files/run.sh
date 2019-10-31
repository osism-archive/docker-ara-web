#!/usr/bin/env sh

cat | tee /usr/share/nginx/html/config.json <<EOL
{
  "apiURL": "http://$ARA_HOST:$ARA_PORT"
}
EOL

exec nginx -g "daemon off;"
