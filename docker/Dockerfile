FROM ruby:2.4.2-alpine

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Michael Weigle <michael.weigle@gmail.com>

ENV BUILD_PACKAGES="build-base" \
    DEV_PACKAGES="zlib-dev libxml2-dev libxslt-dev tzdata postgresql-dev nodejs" \
    CONVENIENCE_PACKAGES="git curl bash docker"

RUN \
  apk --update --upgrade add $BUILD_PACKAGES $CONVENIENCE_PACKAGES $DEV_PACKAGES \
  && bundle config build.nokogiri --use-system-libraries \
  && rm -rf /var/cache/apk/*

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

# Moar bundler
ENV BUNDLE_JOBS=4

CMD ["bash"]
