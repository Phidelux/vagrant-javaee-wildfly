#!/usr/bin/env bash

# Read installation parameters from config.cfg file.
if [ -f /vagrant/vagrant/config.cfg ]; then
  source /vagrant/vagrant/config.cfg
else
  echo "ERROR: file config.cfg not found. Exiting."
  exit 1
fi

echo "
Your WildFly server can be accessed on you local machine:
  Host: localhost
  Port: 8080
  Username: $WILDFLY_USER
  Password: $WILDFLY_PASS

Your PostgreSQL database can be accessed on your local machine on the forwarded port:
  Host: localhost
  Port: 15432
  Database: $POSTGRE_SQL_NAME
  Username: $POSTGRE_SQL_USER
  Password: $POSTGRE_SQL_PASS

Admin access to postgres user via VM:
  vagrant ssh
  sudo su - postgres

psql access to app database user via VM:
  vagrant ssh
  sudo su - postgres
  PGUSER=$POSTGRE_SQL_USER PGPASSWORD=$POSTGRE_SQL_PASS psql -h localhost $POSTGRE_SQL_NAME

Env variable for application development:
  DATABASE_URL=postgresql://$POSTGRE_SQL_USER:$POSTGRE_SQL_PASS@localhost:15432/$POSTGRE_SQL_NAME

Local command to access the database via psql:
  PGUSER=$POSTGRE_SQL_USER PGPASSWORD=$POSTGRE_SQL_PASS psql -h localhost -p 15432 $POSTGRE_SQL_NAME
"
