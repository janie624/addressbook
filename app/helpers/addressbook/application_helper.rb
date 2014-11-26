module Addressbook
  module ApplicationHelper
    def bootstrap_class_for(flash_type)
      case flash_type.to_sym
        when :alert
          "warning"
        when :notice
          "info"
        else
          flash_type.to_s
      end
    end

    def phone_icon_class(phone_type)
      case phone_type
        when 'home', 'cell'
          'earphone'
        when 'mobile', 'iPhone'
          'phone'
        else
          'phone-alt'
      end
    end
  end
end
