#!/bin/bash

#Grab latest from Heroku
heroku pg:backups capture
curl -o latest.dump `heroku pg:backups public-url`

#Reset local DB
RAILS_ENV=production rake db:migrate:reset

#Push
PGPASSWORD="postgres" pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d simrep_production latest.dump

#Fix owners
tables=`psql -qAt -c "select tablename from pg_tables where schemaname = 'public';" simrep_production`

for tbl in $tables ; do
  psql -c "alter table $tbl owner to vagrant" simrep_production ;
done