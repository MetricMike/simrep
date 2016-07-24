# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'SimRep'
set :repo_url, 'file:///mnt/v/Users/Michael/Software/SimTerra/simrep/.git'
set :branch, 'develop'
set :deploy_to, '/mnt/v/Users/Michael/Software/deploy/simrep'

set :rollbar_token, ENV['ROLLBAR_ACCESS_TOKEN']
set :rollbar_env, Proc.new { fetch :stage }
set :rollbar_role, Proc.new { :app }

set :bundle_env_variables, { nokogiri_use_system_libraries: 1 }

set :linked_files, fetch(:linked_files, [])
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'pdfs', 'tmp/cache', 'tmp/sockets', 'public/system')

set :rbenv_ruby, File.read('.ruby-version').strip

set :puma_role, %w(app web db)
set :puma_conf, "#{current_path}/config/puma.rb"

# set :puma_env, :production
# set :puma_threads, 1
# set :puma_workers, 2
# set :puma_bind, "tcp://0.0.0.0:3000, tcp://0.0.0.0:3333"
# set :puma_init_active_record, true
# set :puma_preload_app, true

namespace :deploy do

  desc "Upload the .env files separately (they're not in Git)"
  task :upload_env do
    on roles(:all) do
      upload! '.env', "#{release_path}/.env"
      upload! '.env.production', "#{release_path}/.env.production"
    end
  end

  before :compile_assets, 'deploy:upload_env'
end
