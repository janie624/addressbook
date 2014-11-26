require 'spec_helper'

module Addressbook
  describe Contact do
    before do
      @account = Addressbook::Account.new
      @contacts_json = [{ first_name: Faker::Name.first_name, last_name: Faker::Name.last_name }].to_json
    end

    describe "search" do
      before do
        ActiveResource::HttpMock.respond_to do |mock|
          mock.get    "/api/v1/contacts.json", {"Authorization"=>"Basic YWRkcmVzc2Jvb2s6ZGVmYXVsdHB3", "Accept"=>"application/json", "access_id"=>nil, "secret_key"=>nil}, @contacts_json
        end
      end

      it { Addressbook::Contact.search().should be_a ActiveResource::Collection }
      it { Addressbook::Contact.search().elements.length.should eq 1 }
    end

    describe "import_vcard" do
      before do
        @upload_file = ActionDispatch::Http::UploadedFile.new({
          :original_filename => 'test.vcf',
          :type => 'text/vcard',
          :tempfile => File.new(fixture_path + '/test.vcf')
        })

        ActiveResource::HttpMock.respond_to do |mock|
          mock.get    "/api/v1/contacts/import_vcard.json?account_id=&filename=test.vcf", {"Authorization"=>"Basic YWRkcmVzc2Jvb2s6ZGVmYXVsdHB3", "Accept"=>"application/json", "access_id"=>nil, "secret_key"=>nil}, @contacts_json
        end
      end

      it { Addressbook::Contact.import_vcard(@account, @upload_file).count.should eq 1 }
    end

    describe "import_csv" do
      before do
        @upload_file = ActionDispatch::Http::UploadedFile.new({
          :original_filename => 'test.csv',
          :type => 'text/csv',
          :tempfile => File.new(fixture_path + '/test.csv')
        })

        ActiveResource::HttpMock.respond_to do |mock|
          mock.get    "/api/v1/contacts/import_csv.json?account_id=&filename=test.csv", {"Authorization"=>"Basic YWRkcmVzc2Jvb2s6ZGVmYXVsdHB3", "Accept"=>"application/json", "access_id"=>nil, "secret_key"=>nil}, @contacts_json
        end
      end

      it { Addressbook::Contact.import_csv(@account, @upload_file).count.should eq 1 }
    end

    describe "default attributes of nested resources" do
      it { Addressbook::Contact::Email.new.attributes.should eq({ email: nil, preferred: false }) }
      it { Addressbook::Contact::Address.new.attributes.should eq({ line1: nil, line1: nil, line2: nil, line3: nil, zipcode: nil, city: nil, state: nil, country: nil }) }
      it { Addressbook::Contact::Phone.new.attributes.should eq({ number: nil, phone_type: nil, preferred: false }) }
    end
  end
end
