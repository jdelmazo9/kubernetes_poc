FROM ruby:3.2

WORKDIR /app
COPY ruby_script.rb .
COPY create_volume.rb .
COPY watchdog_script.rb .
