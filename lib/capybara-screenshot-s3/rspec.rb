require 'capybara-screenshot'
require 'capybara-screenshot-s3/rspec/failed_example_notification'

module Capybara
  module Screenshot
    module S3
      module RSpec
        class << self
          def after_failed_example(example)
            if example.example_group.include?(Capybara::DSL)
              Capybara.using_session(Capybara::Screenshot.final_session_name) do
                if Capybara.page.current_url != '' && Capybara::Screenshot.autosave_on_failure && example.exception
                  filename_prefix = Capybara::Screenshot.filename_prefix_for(:rspec, example)

                  saver = Capybara::Screenshot::S3::Saver.new(Capybara, Capybara.page)
                  saver.save

                  example.metadata[:screenshot] = {}
                  example.metadata[:screenshot][:html]  = saver.html_remote_path if saver.html_saved?
                  example.metadata[:screenshot][:image] = saver.screenshot_remote_path if saver.screenshot_saved?
                end
              end
            end
          end
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.before do
    Capybara::Screenshot.final_session_name = nil
  end

  config.after do |example_from_block_arg|
    if Capybara::Screenshot::S3.enabled?
      example = config.respond_to?(:expose_current_running_example_as) ? example_from_block_arg : self.example
      Capybara::Screenshot::S3::RSpec.after_failed_example(example)
    end
  end

  config.before(:suite) do
    if Capybara::Screenshot::S3.enabled?
      custom_formatter = Capybara::Screenshot::S3::RSpec::FailedExampleNotification
      RSpec::Core::Notifications::FailedExampleNotification.include(custom_formatter)
    end
  end

  config.after(:suite) do
    Capybara::Screenshot::S3.flush
  end
end
