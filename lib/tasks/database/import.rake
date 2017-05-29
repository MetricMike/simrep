namespace :db do

    # Stolen from dotenv/tasks so we can load a different file
    desc "Load environment settings from .env"
    task :dotenv do
      require "dotenv"
      Dotenv.load('docker/.simrep.env')
    end

    task environment: :dotenv

    desc 'Imports the database from heroku into local'
    task import: :dotenv do
        ENV_URL = ENV['RAILS_ENV'] || 'development'
        DB_URL = ENV['CMD_DATABASE_URL'].gsub(/\?.+/, "_#{ENV_URL}")
        `heroku pg:backups:download -o latest.dump`
        `pg_restore --verbose --clean --no-acl --no-owner -d '#{DB_URL}' latest.dump`
    end
end