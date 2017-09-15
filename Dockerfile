FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /mastermind
WORKDIR /mastermind
ADD Gemfile /mastermind/Gemfile
ADD Gemfile.lock /mastermind/Gemfile.lock
RUN bundle install && rails db:migrate && bin/rails db:migrate RAILS_ENV=development && rails db:seed
ENTRYPOINT rails s
ADD . /mastermind
