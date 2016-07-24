source 'https://rubygems.org'

# Core Binaries / Engines
gem 'rails', '~> 5.0'
gem 'pg'
gem 'active_record_union'
gem 'high_voltage'
gem 'dotenv-rails'
gem 'puma'

# Rails5 Preliminary for ActiveAdmin
gem 'inherited_resources', github: 'activeadmin/inherited_resources'
gem 'ransack',    github: 'activerecord-hackery/ransack'
gem 'kaminari',   github: 'amatsuda/kaminari', branch: '0-17-stable'
gem 'formtastic', github: 'justinfrench/formtastic'

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
gem 'wkhtmltopdf-heroku'

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

group :development, :test do
  gem 'better_errors'
  gem 'bullet'
  gem 'faker'

  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
  gem 'capistrano-rbenv-install'
  gem 'capistrano3-puma', github: "seuros/capistrano-puma"
  gem 'capistrano-rails'
end

group :test do
  # Better Testing
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'fuubar'
  gem 'codeclimate-test-reporter', group: :test, require: nil
end

group :production do
  # gem 'rails_12factor'
end