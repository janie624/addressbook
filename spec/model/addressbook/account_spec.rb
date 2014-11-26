require 'spec_helper'

module Addressbook
  describe Account do
    before do
      @account_json = { id: 1, name: Faker::Name.name, email: Faker::Internet.email }.to_json
      @contacts_json = [{ id: 1, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name }].to_json
      @groups_json = [{ id: 1, name: Faker::Lorem.word, description: Faker::Lorem.word }].to_json

      ActiveResource::HttpMock.respond_to do |mock|
        mock.get    "/api/v1/accounts/1.json", {"Authorization"=>"Basic YWRkcmVzc2Jvb2s6ZGVmYXVsdHB3", "Accept"=>"application/json", "access_id"=>nil, "secret_key"=>nil}, @account_json
        mock.get    "/api/v1/contacts.json?account_id=1", {"Authorization"=>"Basic YWRkcmVzc2Jvb2s6ZGVmYXVsdHB3", "Accept"=>"application/json", "access_id"=>nil, "secret_key"=>nil}, @contacts_json
        mock.get    "/api/v1/groups.json?account_id=1", {"Authorization"=>"Basic YWRkcmVzc2Jvb2s6ZGVmYXVsdHB3", "Accept"=>"application/json", "access_id"=>nil, "secret_key"=>nil}, @groups_json
      end
    end

    describe "association" do
      before do
        @account = Addressbook::Account.find(1)
      end

      it { @account.contacts.should be_a ActiveResource::Collection }
      it { @account.groups.should be_a ActiveResource::Collection }
      it { @account.contacts.new.should be_a Addressbook::Contact }
      it { @account.groups.new.should be_a Addressbook::Group }
    end

    describe "validation" do
      it { Addressbook::Account.new(email: 'test@gmail.com').should be_valid }
      it { Addressbook::Account.new(email: '').should_not be_valid }
    end
  end
end
