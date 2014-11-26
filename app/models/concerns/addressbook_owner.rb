module AddressbookOwner
  extend ActiveSupport::Concern
  
  included do
    
    def addressbook_account
      if addressbook_account_id.blank?
        addressbook_account = Addressbook::Account.create(email: email, name: owner_name)
        self.update(addressbook_account_id: addressbook_account.id)
      else
        addressbook_account = Addressbook::Account.find(addressbook_account_id)
      end
      
      addressbook_account     
    end

    def owner_name
      if respond_to? :name
        name
      elsif respond_to? :full_name
        full_name
      elsif respond_to? :first_name && :last_name
        [first_name, last_name].reject(&:blank?).join(' ')
      else
        ''
      end
    end
  end
end