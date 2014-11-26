require "addressbook/engine"
require 'carrierwave'
require 'fog'
require 'mini_magick'
require 'kaminari'
require 'jquery-rails'
require "addressbook/base_uploader"
require "addressbook/import_file_uploader"
require "addressbook/photo_uploader"
require "addressbook/resource"
require "addressbook/contact"
require "addressbook/group"
require "addressbook/account"


module Addressbook

  mattr_accessor :user_class

  def self.configure &block
    yield
  end
end
