Addressbook.user_class = 'Account'
Addressbook::Resource.site = 'http://localhost:3001/api/v1/'

AWS_CONFIG = Addressbook::Contact.get :s3_credential unless Rails.env.test?