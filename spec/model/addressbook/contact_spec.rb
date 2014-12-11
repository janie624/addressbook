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

    describe "full_name" do
      it { Addressbook::Contact.new(first_name: 'Test', last_name: 'User').full_name.should eq 'Test User' }
      it { Addressbook::Contact.new(first_name: 'Test').full_name.should eq 'Test' }
    end

    describe "active?" do
      it { Addressbook::Contact.new(status: 'active').active?.should eq true }
      it { Addressbook::Contact.new(status: 'inactive').active?.should eq false }
    end

    describe "nested resources" do
      context "email" do
        it { Addressbook::Contact::Email.new.attributes.should eq({ email: nil, preferred: false }) }
      end

      context "address" do
        it { Addressbook::Contact::Address.new.attributes.should eq({ line1: nil, line1: nil, line2: nil, line3: nil, zipcode: nil, city: nil, state: nil, country: nil }) }
        it { Addressbook::Contact::Address.new(line1: 'Central Park', line2: 'Unit 24').full_address.should eq 'Central Park Unit 24' }
        it { Addressbook::Contact::Address.new(zipcode: '68750', city: 'Berlin').location.should eq '68750 Berlin' }
      end

      context "phone" do
        it { Addressbook::Contact::Phone.new.attributes.should eq({ number: nil, phone_type: nil, preferred: false }) }
      end
    end
  end
end
