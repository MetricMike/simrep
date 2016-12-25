source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Core Binaries / Engines
gem 'rails'
gem 'pg'
gem 'active_record_union'
gem 'high_voltage'

gem 'puma'
gem 'rack-timeout'

# Rails5 Preliminary for ActiveAdmin
gem 'inherited_resources', github: 'activeadmin/inherited_resources'

# Assets
gem 'bootstrap-sass'
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

# Analytics
gem 'newrelic_rpm'
gem 'rollbar'
gem 'oj'

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
# Yeah, this should go in dev/test, but I'm a bad person
# and do live edits in production.
gem 'web-console'
gem 'binding_of_caller'
gem 'jazz_fingers'
gem 'pry-rails'
gem 'pry-byebug'

gem 'sidekiq'

# Gimme The Cache
# https://www.youtube.com/watch?v=OADJl-CVDo0
gem 'redis-rails'
gem 'redis-rack-cache'

group :development, :test do
  gem 'heroku_db_restore'
  gem 'better_errors'
  gem 'active_record_doctor'
  gem 'bullet'
  gem 'faker'
  gem 'active_record_query_trace'
  gem 'letter_opener_web'
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
