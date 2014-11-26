module Addressbook
  module Generators
    class Addressbook::ControllersGenerator < Rails::Generators::Base
      
      source_root File.expand_path('../../../../../', __FILE__)

      public_task :copy_controllers

      desc "This generator copyies controllers to your project from engine.\n"

      argument :name, required: false, default: nil, desc: "The scope to copy controllers to project"

      desc << <<-eos
        Example:
          "rails g addressbook:controllers"
            will copy all addressbook files (controllers and layouts)

          "rails g addressbook:controllers addressbook"
            will copy all addressbook controllers

          "rails g addressbook:controllers addressbook/contacts"
            will copy only contacts controllers

          "rails g addressbook:controllers addressbook/groups"
            will copy only groups controllers

          "rails g addressbook:controllers application"
            will copy addressbook application controller
      eos

      def copy_controllers
        controller_directory name.nil? ? "" : name
      end

      protected

        def controller_directory(name, _target_path = nil)
          directory "app/controllers/#{name}", "app/controllers/#{name}"
        end
    end
  end
end
