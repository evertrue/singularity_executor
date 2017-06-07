require 'net/http'
require 'json'

module SingularityS3Uploader
  module Helpers
    def self.iam_credentials
      response =
        Net::HTTP.get_response(
          URI 'http://169.254.169.254/2016-09-02/meta-data/iam/security-credentials/'
        )
      return unless response.code.to_i == 200
      profile = response.body
      JSON.parse(
        Net::HTTP.get(
          URI "http://169.254.169.254/2016-09-02/meta-data/iam/security-credentials/#{profile}/"
        )
      )
    end
  end
end
