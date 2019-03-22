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

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false

group :development, :test do
  gem "rspec-rails"
  gem "dotenv-rails"
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end