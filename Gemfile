source 'https://rubygems.org'

ruby '2.4.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Core Binaries / Engines
gem 'rails'
gem 'pg'
gem 'oj'
gem 'active_record_union'
gem 'jsonapi-resources'
gem 'high_voltage'
gem 'puma'

# Gimme The Cache
# https://www.youtube.com/watch?v=OADJl-CVDo0
gem 'redis-rails'
gem 'redis-rack-cache'

# Assets
gem 'bootstrap', '~> 4.0.0.alpha5'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether'
  gem 'rails-assets-seiyria-bootstrap-slider'
end

gem 'sassc-rails'
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

# Backgrounding
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'sidekiq-unique-jobs'
gem 'sidekiq-statistic'

# History
gem 'paper_trail'
gem 'paper_trail-globalid'

# PDF Handling
gem 'google_drive', require: false

# Currency handling
gem 'money-rails'

# Convenience Methods
gem 'rounding'

# ActiveAdmin and Friends
gem 'activeadmin', github: 'activeadmin'
gem 'cocoon' #needed for associations
gem 'activeadmin_addons'

# Console and Error handling
gem 'jazz_fingers'
gem 'pry-rails'
gem 'pry-byebug'

# Analytics
gem 'lograge'
gem 'newrelic_rpm'
gem 'rollbar'
gem 'pghero'
gem 'pg_query'
gem 'okcomputer'

# PERF (only active on MTOWER)
gem 'rack-mini-profiler', require: false
gem 'memory_profiler',    require: false
gem 'flamegraph',         require: false
gem 'stackprof',          require: false

group :development, :test do
  gem 'letter_opener_web', require: false
  gem 'faker', require: false

  gem 'bullet'
  gem 'active_record_query_trace', require: false

  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  # Better Testing
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'fuubar'
  gem "simplecov"
  gem 'codeclimate-test-reporter', require: nil
end
