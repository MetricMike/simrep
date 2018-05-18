FROM ruby:2.5-alpine

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
ENV APP_HOME /app/simrep
RUN mkdir -p ${APP_HOME}
WORKDIR $APP_HOME

# Bundle installs with binstubs to our custom /bundle/bin volume path.
# Let system use those stubs.
ENV BUNDLE_PATH=/app/bundle \
    BUNDLE_BIN=/app/bundle/bin \
    GEM_HOME=/app/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

# Set up a non-sudo user
RUN \
  addgroup -S simrep && \
  adduser -S simrep simrep && \
  chown -R simrep:simrep $APP_HOME
USER simrep

CMD ["bash"]
