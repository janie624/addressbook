module Addressbook
  module Generators
    class Addressbook::InitializerGenerator < Rails::Generators::Base
      def create_initializer_file
        create_file "config/initializers/addressbook.rb", "Addressbook.user_class = 'Account'\nAddressbook::Resource.site = 'http://localhost:3001/api/v1/'"
      end
    end
  end
end