FROM alpine:3.7
MAINTAINER Craig Dunn <craig@craigdunn.org>

ENV JERAKIA_CONFIG="/etc/jerakia/config/jerakia.yaml"

RUN apk update && apk upgrade && \
    apk add bash \
            curl-dev \
            ruby-dev \
            build-base && \
    apk add ruby \
            ruby-bundler \
            ruby-io-console \
            sqlite-dev \
            ruby-nokogiri

RUN addgroup -g 99901 jerakia && \
    adduser -u 99901 -G jerakia jerakia -S && \
    mkdir -p /usr/app \
             /etc/jerakia/policy.d \
             /etc/jerakia/config \
             /var/db/jerakia \
             /var/lib/jerakia/plugins \
             /var/lib/jerakia/schema \
             /var/log/jerakia && \
    chown jerakia.jerakia -R /usr/app \
                             /etc/jerakia \
                             /var/db/jerakia \
                             /var/lib/jerakia \
                             /var/log/jerakia

WORKDIR /usr/app
ADD lib ./lib
ADD bin ./bin
COPY Gemfile /usr/app
COPY jerakia.gemspec .

ENV RUBYOPT="-W0"
RUN bundle config build.nokogiri --use-system-libraries && \
    bundle install --without development test
RUN bundle config build.nokogiri --use-system-libraries && \
    bundle install --without development test &&\
    bundle exec gem build jerakia.gemspec && \
    bundle exec gem install --no-rdoc --no-ri ./jerakia*.gem

VOLUME /etc/jerakia \
       /var/db/jerakia \
       /var/lib/jerakia

RUN rm -rf /var/cache/apk*

USER jerakia
ENTRYPOINT ["jerakia"]
CMD ["server", "--bind", "0.0.0.0"]
