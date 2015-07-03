require 'capybara-screenshot/helpers'

module Capybara
  module Screenshot
    module S3
      module RSpec
        module FailedExampleNotification
          def self.included(base)
            if base.method_defined?(:fully_formatted) || base.private_method_defined?(:fully_formatted)
              base.send :alias_method, :fully_formatted_without_screenshot, :fully_formatted
              base.send :alias_method, :fully_formatted, :fully_formatted_with_screenshot
            end
          end

          def fully_formatted_with_screenshot(failure_number, colorizer=::RSpec::Core::Formatters::ConsoleCodes)
            formatted = fully_formatted_without_screenshot(failure_number)

            if screenshot = example.metadata[:screenshot]
              formatted << ("\n    " + CapybaraScreenshot::Helpers.yellow("HTML screenshot: #{screenshot[:html]}")) if screenshot[:html]
              formatted << ("\n    " + CapybaraScreenshot::Helpers.yellow("Image screenshot: #{screenshot[:image]}")) if screenshot[:image]
              formatted << "\n"
            end

            formatted
          end
        end
      end
    end
  end
end
