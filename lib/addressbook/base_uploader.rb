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

      unless Rails.env.test?
        self.fog_credentials = {
          provider:               'AWS',
          aws_access_key_id:      Addressbook.aws_config['access_key_id'],
          aws_secret_access_key:  Addressbook.aws_config['secret_access_key'],
        }
        self.fog_directory = Addressbook.aws_config['bucket']
      end
    end
 
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.token}"
    end

    def cache_dir
      "tmp/uploads"
    end
  end
end