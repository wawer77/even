source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }
#Preinstalled gems
ruby '2.5.1'
gem 'rails', '~> 5.2.1'
gem 'pg', '>= 0.18', '< 2.0'
gem "puma", ">= 4.3.3"
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false

#Added gems
gem 'simple_form'
gem 'bootstrap', '>= 4.4.1'
gem 'devise', '>= 4.7.1'
gem 'gritter', '~> 1.2'
gem 'jquery-rails', '~> 4.3', '>= 4.3.3'
gem 'pundit', '~> 2.0'
gem 'pry-rails', :group => :development
gem 'database_cleaner'

#Security vulnerabilities resolve:
gem 'actionview', '>= 5.2.4.2'
gem 'railties', '>= 5.2.2.1'
gem 'nokogiri', '>= 1.10.8'
gem 'rack', '>= 2.0.8'
gem 'loofah', '>= 2.3.1'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails', '~> 4.11', '>= 4.11.1'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  #gem 'chromedriver-helper'
  #webdriver as chromedriver deprecated
  gem 'webdrivers', '~> 4.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
