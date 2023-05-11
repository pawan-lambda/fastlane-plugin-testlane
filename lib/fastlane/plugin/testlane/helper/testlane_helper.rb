require 'fastlane_core/ui/ui'
require 'rest-client'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class TestLaneHelper
      # class methods that you define here become available in your action
      # as `Helper::TestLane.your_method`
      #
      def self.show_message
        UI.message("Hello from the Lambdatest plugin helper!")
      end

      # Uploads file to Lambdatest
      # Params :
      # +lt_username+:: Lambdatest's username.
      # +lt_access_key+:: Lambdatest's access key.
      # +custom_id+:: Custom id for app upload.
      # +file_path+:: Path to the file to be uploaded.
      # +url+:: Lambdatest's app upload endpoint.
      def self.upload_file(lt_username, lt_access_key, file_path, url, custom_id = nil)
        payload = {
          name: "xyz",
          appFile: File.new(file_path, 'rb')
        }

        unless custom_id.nil?
          payload[:data] = '{ "custom_id": "' + custom_id + '" }'
        end

        headers = {
          "User-Agent" => "fastlane_plugin_testlane"
        }
        begin
          response = RestClient::Request.execute(
            method: :post,
            url: url,
            user: lt_username,
            password: lt_access_key,
            payload: payload,
            headers: headers
          )
          UI.message("Successfull")
          response_json = JSON.parse(response.to_s)
          
          if !response_json["custom_id"].nil?
            return response_json["custom_id"]
          else
            return response_json["app_url"]
          end
        rescue RestClient::ExceptionWithResponse => err
          begin
            error_response = JSON.parse(err.response.to_s)["message"]
          rescue
            error_response = "Internal server error"
          end
          # Give error if upload failed.
          UI.user_error!("App upload failed!!! Reason : #{error_response}")
        rescue StandardError => error
          UI.user_error!("App upload failed!!! Reason : #{error.message}")
        end
      end
    end
  end
end
