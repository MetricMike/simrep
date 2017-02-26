FROM ruby:2.4-alpine

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Michael Weigle <michael.weigle@gmail.com>

ENV BUILD_PACKAGES="build-base" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata postgresql-dev nodejs" \
    CONVENIENCE_PACKAGES="git curl bash"

RUN \
  apk --update --upgrade add $BUILD_PACKAGES $CONVENIENCE_PACKAGES $DEV_PACKAGES && \
  bundle config build.nokogiri --use-system-libraries

# Set an environment variable to store where the app is installed to inside
# of the Docker image.
ENV APP_HOME /var/www/simrep
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# Set up a non-sudo user
RUN \
  addgroup -S simrep && \
  adduser -S simrep simrep && \
  chown -R simrep:simrep $APP_HOME
USER simrep

# Set bundler to use a shared cache
COPY Gemfile .gemrc $APP_HOME/
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile BUNDLE_JOBS=4

# Expose a volume so that nginx will be able to read in assets in production.
# VOLUME ["$APP_HOME/public"]
