source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Core Binaries / Engines
gem 'rails'
gem 'pg'
gem 'active_record_union'
gem 'jsonapi-resources'
gem 'high_voltage'

gem 'puma'

# Tracking master for Rails5
gem 'inherited_resources', github: 'activeadmin/inherited_resources'

# Tracking master for Ruby2.4
gem 'json', github: 'flori/json', branch: 'v1.8'

# Assets
gem 'bootstrap', '~> 4.0.0.alpha5'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'simple_form'
gem 'selectize-rails'
gem 'font-awesome-rails'

# Auth[en|or]
gem 'devise'
gem 'omniauth-facebook'
gem 'pundit'
gem 'jsonapi-authorization'

# Analytics
gem 'newrelic_rpm'
gem 'rollbar'
gem 'oj'
gem 'pghero'
gem 'pg_query'

# Backgrounding
gem 'sidekiq'
gem "sidekiq-cron"
gem 'sidekiq-unique-jobs'

# History
gem 'paper_trail'
gem 'paper_trail-globalid'

# PDF Handling
gem 'wicked_pdf'

# Currency handling
gem 'money-rails'

# Convenience Methods
gem 'rounding'
gem 'constant_cache', github: 'tpitale/constant_cache', branch: 'ar'

# ActiveAdmin and Friends
gem 'activeadmin', github: 'activeadmin'
gem 'cocoon' #needed for associations
gem 'active_admin_csv_import'
gem 'activeadmin-ajax_filter'
gem 'active_admin_datetimepicker'

# Console and Error handling
gem 'jazz_fingers'
gem 'pry-rails'
gem 'pry-byebug'
gem 'pp_sql'

# Gimme The Cache
# https://www.youtube.com/watch?v=OADJl-CVDo0
gem 'redis-rails'
gem 'redis-rack-cache'

group :development, :test do
  gem 'heroku_db_restore'
  gem 'letter_opener_web'

  gem 'active_record_doctor'
  gem 'bullet'
  gem 'active_record_query_trace'

  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'faker'
end

group :test do
  # Better Testing
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'fuubar'
  gem 'codeclimate-test-reporter', require: nil
end
