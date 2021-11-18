# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'
gem 'rails', '~> 7.0.0.alpha2'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'importmap-rails', '>= 0.3.4'
gem 'jbuilder', '~> 2.7'
gem 'puma', '~> 5.0'
gem 'redis', '~> 4.0'
gem 'stimulus-rails', '>= 0.4.0'
gem 'turbo-rails', '>= 0.7.11'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw]

group :development, :test do
  gem 'debug', '>= 1.0.0', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
