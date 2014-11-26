#Addressbook.user_class = 'Account'

Addressbook.configure do
  
  def current_account
    Account.first
  end
end