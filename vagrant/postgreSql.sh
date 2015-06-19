#!/usr/bin/env bash

# Read installation parameters from config.cfg file.
if [ -f /vagrant/vagrant/config.cfg ]; then
  source /vagrant/vagrant/config.cfg
else
  echo "ERROR: file config.cfg not found. Exiting."
  exit 1
fi

if [ ! -f "$POSTGRE_SQL_REPO" ]
then
  # Add the PostgreSql apt repository ...
  echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > "$POSTGRE_SQL_REPO"

  # ... and add the corresponding repository key.
  wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
fi

# Fetch the packages from the newly added repository.
apt-get -y update

# Install PostgreSql.
apt-get -y install "postgresql-$Postgre_SQL_VERSION" "postgresql-contrib-$POSTGRE_SQL_VERSION"

# Edit postgresql.conf to change listen address to '*':
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$POSTGRE_SQL_CONF"

# Append to pg_hba.conf to add password auth:
echo "host    all             all             all                     md5" >> "$POSTGRE_SQL_HBA"

# Explicitly set default client_encoding
echo "client_encoding = utf8" >> "$POSTGRE_SQL_CONF"

# Restart so that all new config is loaded:
service postgresql restart

cat << EOF | su - postgres -c psql
-- Create the database user:
CREATE USER $POSTGRE_SQL_USER WITH PASSWORD '$POSTGRE_SQL_PASS';

-- Create the database:
CREATE DATABASE $POSTGRE_SQL_NAME WITH OWNER=$POSTGRE_SQL_USER
    LC_COLLATE='en_US.utf8' 
    LC_CTYPE='en_US.utf8' 
    ENCODING='UTF8'
    TEMPLATE=template0;
EOF
