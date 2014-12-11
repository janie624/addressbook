require 'active_resource'

module Addressbook
  class Resource < ActiveResource::Base

    include ActiveModel::Validations
    extend ActiveModel::Naming
  
    cattr_accessor :static_headers
    self.static_headers = headers

    self.site = "http://localhost:3001/api/v1/"
    self.user = "addressbook"
    self.password = "defaultpw"
    self.timeout = 180

    def self.headers
      new_headers = static_headers.clone
      new_headers["access_id"] = ENV['addressbook_access_id']
      new_headers["secret_key"] = ENV['addressbook_secret_key']
      new_headers
    end
  end
end
