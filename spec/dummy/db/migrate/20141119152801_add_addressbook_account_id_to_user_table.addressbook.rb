# This migration comes from addressbook (originally 20141110080715)
class AddAddressbookAccountIdToUserTable < ActiveRecord::Migration
  def self.up
    add_column Addressbook.user_class.tableize, :addressbook_account_id, :integer
    add_index Addressbook.user_class.tableize, :addressbook_account_id
  end

  def self.down
    remove_index Addressbook.user_class.tableize, :addressbook_account_id
    remove_column Addressbook.user_class.tableize, :addressbook_account_id
  end
end
