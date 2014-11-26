require 'spec_helper'

module Addressbook
  describe ContactsController do
    describe "GET 'index'" do
      before do
        @contacts_json = [{ first_name: Faker::Name.first_name, last_name: Faker::Name.last_name }].to_json

        ActiveResource::HttpMock.respond_to do |mock|
          mock.get    "/api/v1/contacts.json", {"Authorization"=>"Basic YWRkcmVzc2Jvb2s6ZGVmYXVsdHB3", "Accept"=>"application/json", "access_id"=>nil, "secret_key"=>nil}, @contacts_json
        end
      end

      it "should render index" do
        get :index

        response.should be_success

        should render_template(:index)
      end
    end
  end
end
