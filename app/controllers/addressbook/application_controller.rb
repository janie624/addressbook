module Addressbook
  class ApplicationController < ActionController::Base
    #layout 'layouts/application'
    
    helper_method :current_addressbook_account

    def current_addressbook_account
      @current_addressbook_account = send("current_#{Addressbook.user_class.to_s.underscore}").addressbook_account
    end
  end
end
