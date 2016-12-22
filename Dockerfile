FROM ruby:2.3.3-slim

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Michael Weigle <michael.weigle@gmail.com>

# Install dependencies:
RUN apt-get update -qq

# - build-essential: To ensure certain gems can be compiled
# - git: Cause slim doesn't include it for some bizarre reason
# - nodejs: Compile assets and js runetime
# - libpq-dev: Communicate with postgres through the postgres gem
# - postgresql-client-9.4: In case you want to talk directly to postgres
# - wkhtmltopdf: Generates PDFs for printing at the event
# - libxml2-dev, libxslt1-dev: For nokogiri
RUN apt-get install -qq \
build-essential git nodejs libpq-dev postgresql-client-9.4 wkhtmltopdf \
libxml2-dev libxslt1-dev

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set an environment variable to store where the app is installed to inside
# of the Docker image.
ENV APP_HOME /var/www/simrep
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# Run bundler with shared cache
COPY Gemfile .gemrc $APP_HOME/
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile BUNDLE_JOBS=2
RUN bundle install

COPY . $APP_HOME

# Expose a volume so that nginx will be able to read in assets in production.
VOLUME ["$APP_HOME/public"]

RUN groupadd -r simrep && useradd -r -g simrep simrep
USER simrep

CMD ./bin/start_web