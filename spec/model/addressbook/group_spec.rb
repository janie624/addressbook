require 'spec_helper'

module Addressbook
  describe Group do

    describe "validation" do
      it { Addressbook::Group.new(name: 'Test group').should be_valid }
      it { Addressbook::Group.new(name: '').should_not be_valid }
    end
  end
end
