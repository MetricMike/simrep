source 'https://rubygems.org'

# Core Binaries
gem 'rails', '~> 5.0.0.rc1'
gem 'pg', '0.18.2'
gem 'passenger'
gem 'dotenv-rails'

gem 'high_voltage'

# Assets
gem 'bootstrap-sass'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks', '~> 5.0.0.beta'
gem 'simple_form'
gem 'selectize-rails'
gem "font-awesome-rails"

# Auth[en|or]
gem 'devise'
gem 'omniauth-facebook'
gem 'pundit'

# Analytics
gem 'newrelic_rpm'
gem 'rollbar'
gem 'oj', '~> 2.12.14'

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
gem 'activeadmin_addons'
gem 'responsive_active_admin'

# Console and Error handling
# Yeah, this should go in dev/test, but I'm a bad person
# and do live edits in production.
gem 'web-console'
gem "binding_of_caller"
gem 'jazz_fingers'
gem 'pry-rails'
gem 'pry-byebug'

group :development, :test do
  gem "better_errors"
  gem 'bullet'
  gem 'quiet_assets'
  gem 'faker'
end

group :test do
  # Better Testing
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'fuubar'
  gem "codeclimate-test-reporter", group: :test, require: nil
end

group :production do
  gem 'rails_12factor'
end