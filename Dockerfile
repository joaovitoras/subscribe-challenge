FROM ruby:3.4.2

RUN apt-get update && \
  apt-get install -yq --no-install-recommends \
  ruby-dev

RUN adduser challenge
USER challenge
WORKDIR /home/challenge/app

COPY --chown=challenge Gemfile Gemfile.lock ./

RUN bundle install --jobs=3 --retry=3
