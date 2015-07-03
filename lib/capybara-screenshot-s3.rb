require "capybara-screenshot-s3/version"
require 'capybara-screenshot-s3/saver'
require 'capybara-screenshot-s3/uploader'

module Capybara
  module Screenshot
    module S3
      class << self
        attr_accessor :enabled
        attr_accessor :upload_inline

        def configure(&block)
          @uploader = Uploader.new
          @uploader.instance_eval(&block)
          unless @uploader.bucket_name
            raise 'Capybara::Screenshot::S3 - You must specify a bucket for S3 uploads'
          end
          @queue = []
        end

        delegate :upload, :url_for, :signed_url_for, :bucket_url, to: :@uploader

        def enqueue(path)
          @queue << path
        end

        def flush
          @queue.each { |p| @uploader.upload(p) }
          @queue = []
        end

        def enabled?
          !!enabled
        end

        def upload_inline?
          !!upload_inline
        end
      end

      self.enabled       = true
      self.upload_inline = false
    end
  end
end
