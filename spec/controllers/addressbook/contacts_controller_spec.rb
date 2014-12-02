require 'spec_helper'

module Addressbook
  describe ContactsController do
    routes { Addressbook::Engine.routes }

    before do
      @contacts_json  = [{ first_name: Faker::Name.first_name, last_name: Faker::Name.last_name }].to_json
      @account_json   = { id: 1, email: "test@test.com", name: "Alexander K." }.to_json

      ActiveResource::HttpMock.respond_to do |mock|
        mock.post   "/api/v1/accounts.json", { "Authorization"=>"Basic YWRkcmVzc2Jvb2s6ZGVmYXVsdHB3", "Content-Type"=>"application/json", "access_id"=>nil, "secret_key"=>nil }, @account_json, 201, "Location" => "/api/v1/accounts/1.json"
        mock.get    "/api/v1/contacts.json?account_id=1&action=index&controller=addressbook%2Fcontacts", {"Authorization"=>"Basic YWRkcmVzc2Jvb2s6ZGVmYXVsdHB3", "Accept"=>"application/json", "access_id"=>nil, "secret_key"=>nil}, @contacts_json
        mock.get    "/api/v1/contacts.json?account_id=1", {"Authorization"=>"Basic YWRkcmVzc2Jvb2s6ZGVmYXVsdHB3", "Accept"=>"application/json", "access_id"=>nil, "secret_key"=>nil}, @contacts_json
      end
    end

    describe "GET 'index'" do
      it "should render index" do
        get :index

        should render_template :index
      end
    end

    describe "GET 'new'" do
      it "should render new" do
        get :new

        should render_template :new
      end
    end

    describe "POST 'create'" do
      it "should redirect to contacts path with validation" do
        Addressbook::Contact.any_instance.should_receive(:save).and_return(true)

        post :create

        should redirect_to contacts_path
      end

      it "should render new with invalidation" do
        Addressbook::Contact.any_instance.should_receive(:save).and_return(false)

        post :create

        should render_template :new
      end
    end

    describe "GET 'edit'" do
      before :each do
        @contact = mock_model Contact
        Addressbook::Contact.should_receive(:find).and_return(@contact)
      end

      it "should render edit" do
        get :edit, id: @contact.id

        should render_template :edit
      end
    end

    describe "PUT 'update'" do
      before :each do
        @contact = mock_model Contact
        Addressbook::Contact.should_receive(:find).and_return(@contact)
      end

      it "should redirect to contacts path with validation" do
        @contact.should_receive(:update_attributes).and_return(true)

        put :update, id: @contact.id

        should redirect_to contacts_path
      end

      it "should render edit with invalidation" do
        @contact.should_receive(:update_attributes).and_return(false)

        put :update, id: @contact.id

        should render_template :edit
      end
    end

    describe "DELETE 'destroy'" do
      before :each do
        @contact = mock_model Contact
        Addressbook::Contact.should_receive(:find).and_return(@contact)
      end

      it "should render destroy" do
        delete :destroy, id: @contact.id, format: :js

        should render_template :destroy
      end
    end

    describe "POST 'import_vcard'" do
      context "valid vcard file" do
        before do
          @upload_file = ActionDispatch::Http::UploadedFile.new({
            :original_filename => 'test.vcf',
            :type => 'text/vcard',
            :tempfile => File.new(fixture_path + '/test.vcf')
          })
        end

        it "should redirect to contacts path after importing" do
          post 'import_vcard', vcard: @upload_file

          should redirect_to contacts_path
        end
      end

      context "invalid vcard file" do
        before do
          @upload_file = ActionDispatch::Http::UploadedFile.new({
            :original_filename => 'invalid_vcard',
            :type => 'text/vcard',
            :tempfile => File.new(fixture_path + '/test.vcf')
          })
        end

        it "should redirect to contacts path without importing" do
          post 'import_vcard', vcard: @upload_file

          should redirect_to contacts_path
        end
      end
    end

    describe "POST 'import_csv'" do
      context "valid csv file" do
        before do
          @upload_file = ActionDispatch::Http::UploadedFile.new({
            :original_filename => 'test.vcf',
            :type => 'text/csv',
            :tempfile => File.new(fixture_path + '/test.vcf')
          })
        end

        it "should redirect to contacts path after importing" do
          post 'import_csv', csv: @upload_file

          should redirect_to contacts_path
        end
      end

      context "invalid csv file" do
        before do
          @upload_file = ActionDispatch::Http::UploadedFile.new({
            :original_filename => 'invalid_csv',
            :type => 'text/csv',
            :tempfile => File.new(fixture_path + '/test.vcf')
          })
        end

        it "should redirect to contacts path without importing" do
          post 'import_csv', csv: @upload_file

          should redirect_to contacts_path
        end
      end
    end
  end
end
