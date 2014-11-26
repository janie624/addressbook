require 'spec_helper'

module Addressbook
  describe Resource do

    it { Addressbook::Resource.site.to_s.should eq 'http://localhost:3001/api/v1/' }
    it { Addressbook::Resource.user.should eq 'addressbook' }
    it { Addressbook::Resource.password.should eq 'defaultpw' }
  end
end
