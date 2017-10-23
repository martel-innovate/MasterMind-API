FROM ruby:2.4.1
ENV MASTERMIND_VERSION Undefined
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs git
RUN mkdir /mastermind
WORKDIR /mastermind
ADD Gemfile /mastermind/Gemfile
ADD Gemfile.lock /mastermind/Gemfile.lock
RUN bundle install
ENTRYPOINT rails db:setup && rails s
ADD . /mastermind
RUN git clone https://github.com/martel-innovate/MasterMind-Service-Catalog mastermind-services
