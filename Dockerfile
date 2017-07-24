FROM alpine:3.6
MAINTAINER Craig Dunn <craig@craigdunn.org>

ARG RUNTIME_UID=99901
ARG RUNTIME_GID=99901

ENV RUBYOPTS="-W0"  JERAKIA_CONFIG="/etc/jerakia/config/jerakia.yaml"

RUN apk update && apk upgrade && apk add bash curl-dev ruby-dev build-base && \
    apk add ruby ruby-bundler ruby-io-console sqlite-dev ruby-nokogiri


RUN addgroup -g $RUNTIME_GID jerakia && adduser -u $RUNTIME_UID -G jerakia jerakia -S && \
    mkdir -p /usr/app /var/log/jerakia /etc/jerakia /etc/jerakia/policy.d /var/db/jerakia /var/lib/jerakia/plugins /var/lib/jerakia/schema /etc/jerakia/config && \
    chown jerakia.jerakia -R /usr/app /var/log/jerakia /var/db/jerakia /var/lib/jerakia/plugins /var/lib/jerakia/schema /etc/jerakia

VOLUME /etc/jerakia/policy.d /var/lib/jerakia/plugins /var/lib/jerakia/data /var/lib/jerakia/schema /var/db/jerakia /etc/jerakia/config

WORKDIR /usr/app

ADD lib ./lib
ADD bin ./bin
COPY Gemfile /usr/app
COPY jerakia.gemspec .

RUN bundle config build.nokogiri --use-system-libraries && \
    bundle install --without development test

RUN bundle config build.nokogiri --use-system-libraries && \
    bundle install --without development test &&\
    bundle  exec gem build jerakia.gemspec && \
    bundle exec gem install --no-rdoc --no-ri ./jerakia*.gem

VOLUME /etc/jerakia/policy.d /var/lib/jerakia/plugins /var/lib/jerakia/data /var/lib/jerakia/schema /var/db/jerakia /etc/jerakia/config

RUN rm -rf /var/cache/apk*

USER jerakia
ENTRYPOINT ["jerakia"]
CMD ["server"]
