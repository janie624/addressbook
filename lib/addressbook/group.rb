module Addressbook
  class Group < Resource

    validates_presence_of :name

    module RelationExtensions
      def new(params = {})
        params.merge!(original_params)
        resource_class.new(params)
      end
    end

    schema do
      attribute 'name',         :string
      attribute 'description',  :string
    end
  end
end
