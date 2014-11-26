require_dependency "addressbook/application_controller"

module Addressbook
  class ContactsController < ApplicationController

    before_filter :load_resource, only: [:edit, :update, :destroy]
    before_filter :store_photo, only: [:update]

    def index
      contacts = Addressbook::Contact.search(params.merge(account_id: current_addressbook_account.id))
      @contacts = Kaminari::PaginatableArray.new(
        contacts, {
          limit: contacts.http_response['X-limit'].to_i,
          offset: contacts.http_response['X-offset'].to_i,
          total_count: contacts.http_response['X-total'].to_i
        })
    end

    def new
      @contact = Addressbook::Contact.new
      @contact.groups = []
      @contact.emails = []
      @contact.addresses = []
      @contact.phones = []
    end

    def create
      @contact = current_addressbook_account.contacts.new(contact_params)
      store_photo

      if @contact.save
        redirect_to contacts_path, notice: t('addressbook.contact.create_notice')
      else
        render :new
      end
    end

    def edit
      
    end

    def update
      if @contact.update_attributes(contact_params)
        redirect_to contacts_path, notice: t('addressbook.contact.update_notice')
      else
        render :edit
      end
    end

    def destroy
      @contact.destroy
    end

    def import_vcard
      if !params[:vcard].nil? && /(.*)?\.vcf/ =~ params[:vcard].original_filename
        contacts = Addressbook::Contact.import_vcard(current_addressbook_account, params[:vcard])
        redirect_to contacts_path, notice: t('addressbook.contact.import_notice', count: contacts.length)
      else
        redirect_to contacts_path, alert: t('addressbook.contact.invalid_vcard')
      end
    end

    def import_csv
      if !params[:csv].nil? && /(.*)?\.csv/ =~ params[:csv].original_filename
        contacts = Addressbook::Contact.import_csv(current_addressbook_account, params[:csv])
        redirect_to contacts_path, notice: t('addressbook.contact.import_notice', count: contacts.length)
      else
        redirect_to contacts_path, alert: t('addressbook.contact.invalid_csv')
      end
    end


    private

    def load_resource
      @contact = Addressbook::Contact.find(params[:id])
    end

    def store_photo
      return unless params[:contact][:photo]
      @contact.token = SecureRandom.urlsafe_base64 if @contact.token.blank?
      @contact.photo = params[:contact][:photo]
      @contact.store_photo!
      @contact.photo_file_name = @contact.photo.filename
    end

    def contact_params
      params.fetch(:contact, {})
        .permit(:first_name, :last_name, :nickname, :title, :gender, :dob, :company, :homepage, group_ids: [],
          emails_attributes: [:id, :email, :preferred, :_destroy],
          addresses_attributes: [:id, :line1, :line2, :line3, :city, :zipcode, :country, :state, :_destroy],
          phones_attributes: [:id, :number, :phone_type, :preferred, :_destroy]
        )
    end
  end
end
