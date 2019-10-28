#!/usr/bin/env sh

# Available environment variables
#
# ARA_HOST
# ARA_PORT

# Set default values

ARA_HOST=${ARA_HOST:-ara-server}
ARA_PORT=${ARA_PORT:-8000}

cat | tee $HOME/ara-web/public/config.json $HOME/ara-web/build/config.json <<EOL
{
  "apiURL": "http://$ARA_HOST:$ARA_PORT"
}
EOL

exec serve -s build -l 3000
