source "https://rubygems.org"

ruby "2.5.1"

gem "rails", "~> 5.2.2", ">= 5.2.2.1"
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 3.11"
gem "bcrypt", "~> 3.1.7"
gem "jwt"
gem "simple_command"
gem "http"
gem "pry"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

group :development, :test do
  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, :git => "https://github.com/rspec/#{lib}.git", :branch => "master"
  end

  gem "factory_bot"
  gem "pry-byebug"
  gem "rack-test", require: "rack/test"
  gem "dotenv-rails"
  gem "rubocop"
  gem "timecop"
  gem "webmock"
  gem "database_cleaner"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end
