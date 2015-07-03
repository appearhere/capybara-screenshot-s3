# Capybara::Screenshot::S3

Building on top of [capybara-screenshot](https://github.com/mattheworiordan/capybara-screenshot) to automatically upload screenshots to an S3 bucket.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capybara-screenshot-s3', group: :test
```

#### Rspec

In `spec_helper.rb`, add:

```ruby
require 'capybara-screenshot-s3/rspec'
```

## Configuration

```ruby
Capybara::Screenshot::S3.configure do |config|
  config.access_key_id     = ENV['AWS_ACCESS_KEY_ID']
  config.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  config.bucket_name       = 'my-ci-bucket-name'
  config.folder            = "capybara/#{ ENV['TRAVIS_BUILD_NUMBER'] }/"
end
```

You can control S3 uploading with the `enabled` option:

```ruby
Capybara::Screenshot::S3.enabled = ENV.fetch('TRAVIS', false)
```

The S3 bucket URL is also exposed, which is useful if you use VCR:

```ruby
VCR.configuration.ignore_hosts << URI.parse(Capybara::Screenshot::S3.bucket_url).host
```

## Credits

The original `capybara-screenshot` gem was written by **Matthew O'Riordan**, with contributions from [many kind people](https://github.com/mattheworiordan/capybara-screenshot/network/members).

 - [mattheworiordan/capybara-screenshot](https://github.com/mattheworiordan/capybara-screenshot)
 - [HealthTeacher/capybara-screenshot](https://github.com/HealthTeacher/capybara-screenshot)
 - [http://mattheworiordan.com](http://mattheworiordan.com)
 - [@mattheworiordan](http://twitter.com/#!/mattheworiordan)
 - [Linked In](http://www.linkedin.com/in/lemon)
