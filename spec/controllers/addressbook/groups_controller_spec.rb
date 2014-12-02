require 'spec_helper'

module Addressbook
  describe GroupsController do
    routes { Addressbook::Engine.routes }

    before do
      @groups_json  = [{ name: Faker::Lorem.word, description: Faker::Lorem.sentence }].to_json
      @account_json   = { id: 1, email: "test@test.com", name: "Alexander K." }.to_json

      ActiveResource::HttpMock.respond_to do |mock|
        mock.post   "/api/v1/accounts.json", { "Authorization"=>"Basic YWRkcmVzc2Jvb2s6ZGVmYXVsdHB3", "Content-Type"=>"application/json", "access_id"=>nil, "secret_key"=>nil }, @account_json, 201, "Location" => "/api/v1/accounts/1.json"
        mock.get    "/api/v1/groups.json?account_id=1&action=index&controller=addressbook%2Fgroups", {"Authorization"=>"Basic YWRkcmVzc2Jvb2s6ZGVmYXVsdHB3", "Accept"=>"application/json", "access_id"=>nil, "secret_key"=>nil}, @groups_json
        mock.get    "/api/v1/groups.json?account_id=1", {"Authorization"=>"Basic YWRkcmVzc2Jvb2s6ZGVmYXVsdHB3", "Accept"=>"application/json", "access_id"=>nil, "secret_key"=>nil}, @groups_json
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
      before :each do
        request.env["HTTP_REFERER"] = root_url
      end

      it "should redirect to groups path with validation" do
        Addressbook::Group.any_instance.should_receive(:save).and_return(true)

        post :create

        should redirect_to root_path
      end

      it "should render new with invalidation" do
        Addressbook::Group.any_instance.should_receive(:save).and_return(false)

        post :create

        should render_template :new
      end
    end

    describe "GET 'edit'" do
      before :each do
        @group = mock_model Group
        Addressbook::Group.should_receive(:find).and_return(@group)
      end

      it "should render edit" do
        get :edit, id: @group.id

        should render_template :edit
      end
    end

    describe "PUT 'update'" do
      before :each do
        @group = mock_model Group
        Addressbook::Group.should_receive(:find).and_return(@group)
        request.env["HTTP_REFERER"] = root_url
      end

      it "should redirect to groups path with validation" do
        @group.should_receive(:update_attributes).and_return(true)

        put :update, id: @group.id

        should redirect_to root_path
      end

      it "should render edit with invalidation" do
        @group.should_receive(:update_attributes).and_return(false)

        put :update, id: @group.id

        should render_template :edit
      end
    end

    describe "DELETE 'destroy'" do
      before :each do
        @group = mock_model Group
        Addressbook::Group.should_receive(:find).and_return(@group)
      end

      it "should render destroy" do
        delete :destroy, id: @group.id, format: :js

        should render_template :destroy
      end
    end
  end
end
