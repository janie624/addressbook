# encoding: utf-8

module Addressbook
  class BaseUploader < CarrierWave::Uploader::Base
    if Rails.env.test? or Rails.env.cucumber?# or (Rails.env.development? and Figaro.env.host == 'localhost:3000')
      storage :file
    else
      storage :fog
    end

    def initialize(*)
      super

      self.fog_credentials = {
        provider:               'AWS',
        aws_access_key_id:      AWS_CONFIG['access_key_id'],
        aws_secret_access_key:  AWS_CONFIG['secret_access_key'],
      }
      self.fog_directory = AWS_CONFIG['bucket']
    end
 
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.token}"
    end

    def cache_dir
      "tmp/uploads"
    end
  end
end