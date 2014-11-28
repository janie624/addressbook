require 'active_resource_response'

module Addressbook
  class Contact < Resource
    extend CarrierWave::Mount

    self.element_name = "contact"
    add_response_method :http_response

    GENDER = %w(male female)

    mount_uploader :photo, PhotoUploader

    module RelationExtensions
      def new(params = {})
        params.merge!(original_params)
        resource_class.new(params)
      end

      def count
        http_response['X-total'].to_i
      end
    end

    def self.search(query = {})
      self.find(:all, params: query)
    end

    def self.import_vcard(account, vcard)
      uploader = ImportFileUploader.new
      File.open(vcard.tempfile) { |file| uploader.store!(file) }
      Addressbook::Contact.get :import_vcard, { account_id: account.id, filename: uploader.filename }
    end

    def self.import_csv(account, csv)
      uploader = ImportFileUploader.new
      File.open(csv.tempfile) { |file| uploader.store!(file) }
      Addressbook::Contact.get :import_csv, { account_id: account.id, filename: uploader.filename }
    end

    def full_name
      [first_name, last_name].reject(&:blank?).join(' ')
    end

    schema do
      attribute 'first_name',   :string
      attribute 'last_name',    :string
      attribute 'nickname',     :string
      attribute 'title',        :string
      attribute 'gender',       :string
      attribute 'company',      :string
      attribute 'homepage',     :string
      attribute 'dob',          :string
      attribute 'group_ids',    :string
      attribute 'token',        :string
      attribute 'status',       :integer
      attribute 'photo_file_name', :string
    end

    class Nested < Resource
      def initialize(attributes={}, persisted=false)
        @attributes = attributes.present? ? attributes.stringify_keys : default_attributes
      end
    end

    class Email < Nested

      schema do
        attribute 'email',        :string
        attribute 'preferred',    :boolean
      end

      private

      def default_attributes
        { email: nil, preferred: false }
      end
    end

    class Address < Nested

      def full_address
        [line1, line2, line3].reject(&:blank?).join(' ') 
      end

      def location
        [zipcode, city, state].reject(&:blank?).join(' ')
      end

      schema do
        attribute 'line1',        :string
        attribute 'line2',        :string
        attribute 'line3',        :string
        attribute 'zipcode',      :string
        attribute 'city',         :string
        attribute 'state',        :string
        attribute 'country',      :string
      end

      private

      def default_attributes
        { line1: nil, line2: nil, line3: nil, zipcode: nil, city: nil, state: nil, country: nil }
      end
    end

    class Phone < Nested

      TYPES = %w(mobile home iPhone cell work other)

      schema do
        attribute 'number',       :string
        attribute 'phone_type',   :string
        attribute 'preferred',    :boolean
      end

      private

      def default_attributes
        { number: nil, phone_type: nil, preferred: false }
      end
    end
  end
end
