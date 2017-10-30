require 'aws-sdk-s3'

module Capybara
  module Screenshot
    module S3
      class Uploader
        attr_writer :access_key_id
        attr_writer :secret_access_key
        attr_writer :bucket_name
        attr_writer :folder
        attr_writer :region
        attr_writer :expiry

        delegate :url, to: :bucket, prefix: true

        def upload(path)
          key = key_for(path)

          object(key).upload_file(path)
        end

        def client
          @client ||= Aws::S3::Client.new(client_options)
        end

        def client_options
          options = { region: region }
          options[:credentials] = credentials if credentials
          options
        end

        def credentials
          @credentials ||= if @access_key_id && @secret_access_key
            Aws::Credentials.new(@access_key_id, @secret_access_key)
          end
        end

        def region
          @region || 'eu-west-1'
        end

        def bucket_name
          @bucket_name
        end

        def resource
          @resource ||= Aws::S3::Resource.new(client: client)
        end

        def bucket
          @bucket ||= resource.bucket(bucket_name)
        end

        def object(key)
          bucket.object(key)
        end

        def folder
          @folder
        end

        def expiry
          @expiry || 3600
        end

        def signed_url_for(path)
          key = key_for(path)

          object(key).presigned_url(:get, expires_in: expiry)
        end

        def url_for(path)
          key = key_for(path)

          "#{ bucket_url }/#{ key }"
        end

        def key_for(path)
          key = File.basename(path)
          File.join(folder, key) if folder
        end
      end
    end
  end
end
