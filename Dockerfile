FROM ruby:2.4-slim

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Michael Weigle <michael.weigle@gmail.com>

# Install dependencies:
RUN apt-get update -qq

# - build-essential: To ensure certain gems can be compiled
# - git: Cause slim doesn't include it
# - nodejs: Compile assets and js runtime
# - libpq-dev: Communicate with postgres through the postgres gem
# - postgresql-client: In case you want to talk directly to postgres
# - wkhtmltopdf: Generates PDFs for printing at the event
# - libxml2-dev, libxslt1-dev: For nokogiri
RUN apt-get install -qq \
build-essential git nodejs libpq-dev postgresql-client wkhtmltopdf \
libxml2-dev libxslt1-dev

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set an environment variable to store where the app is installed to inside
# of the Docker image.
ENV APP_HOME /var/www/simrep
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# Set up a non-sudo user
RUN adduser --group --system simrep
RUN chown -R simrep:simrep $APP_HOME
USER simrep

# Run bundler with shared cache
COPY Gemfile .gemrc $APP_HOME/
ENV BUNDLE_PATH=/usr/local/bundle BUNDLE_GEMFILE=$APP_HOME/Gemfile BUNDLE_JOBS=2
RUN bundle install
# RUN chown -R simrep:simrep /usr/local/bundle

COPY . $APP_HOME

# RUN chmod +x bin/*

# Expose a volume so that nginx will be able to read in assets in production.
# VOLUME ["$APP_HOME/public"]
