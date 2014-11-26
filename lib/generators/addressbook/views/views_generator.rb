module Addressbook
  module Generators
    class Addressbook::ViewsGenerator < Rails::Generators::Base
      
      source_root File.expand_path('../../../../../', __FILE__)

      public_task :copy_views

      desc "This generator copyies views to your project from engine.\n"

      argument :name, required: false, default: nil, desc: "The scope to copy views to project"

      desc << <<-eos
        Example:
          "rails g addressbook:views"
            will copy all addressbook files (views and layouts)

          "rails g addressbook:views addressbook"
            will copy all addressbook views

          "rails g addressbook:views addressbook/contacts"
            will copy only contacts views

          "rails g addressbook:views addressbook/groups"
            will copy only groups views

          "rails g addressbook:views layouts"
            will copy addressbook layouts
      eos

      def copy_views
        view_directory name.nil? ? "" : name
      end

      protected

        def view_directory(name, _target_path = nil)
          directory "app/views/#{name}", "app/views/#{name}"
        end
    end
  end
end
