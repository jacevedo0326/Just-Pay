#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Database migrations need to be run during build on free tier
bundle exec rails db:migrate