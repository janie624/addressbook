module Addressbook
  class Account < Resource

    has_many :contacts, class_name: 'Addressbook::Contact'
    has_many :groups, class_name: 'Addressbook::Group'

    validates_presence_of :email

    alias_method :original_contacts, :contacts
    alias_method :original_groups, :groups

    def contacts
      original_contacts.extend Addressbook::Contact::RelationExtensions
      original_contacts
    end

    def groups
      original_groups.extend Addressbook::Group::RelationExtensions
      original_groups
    end    

    schema do
      attribute 'email',    :string
      attribute 'name',     :string
    end
  end
end
