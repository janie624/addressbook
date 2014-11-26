# Addressbook

## Installation

Add this line to your application's Gemfile:

    $ gem 'addressbook'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install addressbook


## General configuration options

Set addressbook owner class name and addressbook cloud server site url in config/initialize/addressbook.rb. Default class name is 'Account'.

    $ rails g addressbook:initializer

```ruby
# config/initializers/addressbook.rb

Addressbook.user_class = 'User'
Addressbook::Resource.site = 'http://localhost:3001/api/v1/'
```

Add this line to addressbook owner model.

```ruby
# app/models/account.rb

class Account < ActiveRecord::Base
  include AddressbookOwner
  ...
```


Set your own ENV['addressbook_access_id'], ENV['addressbook_secret_key'] that was generated on addressbook cloud server.


## Install migrations
    $ rake db:create
    $ rake addressbook:install:migrations
    $ rake db:migrate
    $ rake db:seed (seeds accounts to dummy app)

## Running test server
    $ cd spec/dummy/
    $ rails s

## Mounting addressbook engine

```ruby
Rails.application.routes.draw do
  mount Addressbook::Engine => "/addressbook"
  ...
end
```

Adressbook contacts can be seen by visiting "/addressbook".


## Customization

### Model structure

Let's assume that addressbook owner class name is 'Account'.
Object of Account model will have many Addressbook::Contact and Addressbook::Group.
Addressbook::Contact has many Addressbook::Email, Addressbook::Address and Addressbook::Phone.


### Overriding Controller

Generate controllers by following;

    $ rails g addressbook:controllers

Application helper method current_addressbook_account will create a new Addressbook::Account object on addressbook cloud server or retrieve existing object from cloud server. Or use current_user.addressbook_account.

You can now create, update or destroy Addressbook::Contact the same as with ActiveRecord. For example;

```ruby
contact = current_addressbook_account.contacts.new(first_name: "Philip", last_name: "K.", nickname: "Philip", gender: "male", company: "Apple Inc.", ...)
contact.save
```

```ruby
contact.update_attributes(contact_params)
```

```ruby
contact.destroy
```

Index and search Addressbook::Contact

```ruby
contacts = current_addressbook_account.contacts
```

```ruby
contacts = Addressbook::Contact.search(params.merge(account_id: current_addressbook_account.id))
```

Never forget merge account_id into params when using Addressbook::Contact.search.

The same can be said with Addressbook::Group.

Pagination with Addressbook::Contact collection;

```ruby
contacts = Addressbook::Contact.search(params.merge(account_id: current_addressbook_account.id))
@contacts = Kaminari::PaginatableArray.new(
contacts, {
  limit: contacts.http_response['X-limit'].to_i,
  offset: contacts.http_response['X-offset'].to_i,
  total_count: contacts.http_response['X-total'].to_i
})
```


### Overriding Views

Generate views by following;

    $ rails g addressbook:views

