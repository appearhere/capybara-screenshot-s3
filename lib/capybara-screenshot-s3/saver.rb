module Capybara
  module Screenshot
    module S3
      class Saver
        attr_reader :capybara, :page, :file_base_name

        def initialize(capybara, page)
          @capybara = capybara
          @page     = page

          time_now = Time.now
          timestamp = "#{time_now.strftime('%Y-%m-%d-%H-%M-%S.')}#{'%03d' % (time_now.usec/1000).to_i}"

          filename = ['screenshot']
          filename << timestamp if Capybara::Screenshot.append_timestamp

          @file_base_name = filename.join('_')

          Capybara::Screenshot.prune
        end

        def save
          return if capybara.current_path.to_s.empty?

          save_html
          save_screenshot
        end

        def save_html
          capybara.save_page("#{ html_path }")
          @html_saved = true
          upload_or_enqueue(html_path)
        end

        def save_screenshot
          result = Capybara::Screenshot.registered_drivers.fetch(capybara.current_driver) { |driver_name|
            warn "capybara-screenshot could not detect a screenshot driver for '#{capybara.current_driver}'. Saving with default with unknown results."
            Capybara::Screenshot.registered_drivers[:default]
          }.call(page.driver, screenshot_path)

          @screenshot_saved = (result != :not_supported)
          upload_or_enqueue(screenshot_path) if @screenshot_saved
        end

        def html_remote_path
          Capybara::Screenshot::S3.signed_url_for("#{file_base_name}.html")
        end

        def html_path
          File.join(Capybara::Screenshot.capybara_root, "#{file_base_name}.html")
        end

        def screenshot_remote_path
          Capybara::Screenshot::S3.signed_url_for("#{file_base_name}.png")
        end

        def screenshot_path
          File.join(Capybara::Screenshot.capybara_root, "#{file_base_name}.png")
        end

        def html_saved?
          @html_saved
        end

        def screenshot_saved?
          @screenshot_saved
        end

        private

        def upload_or_enqueue(path)
          method = Capybara::Screenshot::S3.upload_inline? ? :upload : :enqueue
          Capybara::Screenshot::S3.send(method, path)
        end
      end
    end
  end
end
