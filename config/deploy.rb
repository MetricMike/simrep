# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'SimRep'
set :repo_url, 'file:///mnt/v/Users/Michael/Software/SimTerra/simrep/.git'

set :rollbar_token, ENV['ROLLBAR_ACCESS_TOKEN']
set :rollbar_env, Proc.new { fetch :stage }
set :rollbar_role, Proc.new { :app }
set :bundle_env_variables, { nokogiri_use_system_libraries: 1 }

set :deploy_to, '/mnt/v/Users/Michael/Software/deploy/simrep'

set :linked_files, fetch(:linked_files, []).push('.env')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'pdfs', 'tmp/cache', 'tmp/sockets', 'public/system')

set :rbenv_ruby, File.read('.ruby-version').strip

set :puma_conf, "#{current_path}/puma.rb"
