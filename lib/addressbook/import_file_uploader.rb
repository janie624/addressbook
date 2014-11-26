module Addressbook
  class ImportFileUploader < BaseUploader
    def store_dir
      "uploads/addressbook/contact/imported"
    end
  end
end
