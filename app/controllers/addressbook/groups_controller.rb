require_dependency "addressbook/application_controller"

module Addressbook
  class GroupsController < ApplicationController

    before_filter :load_resource, except: [:index, :new, :create]

    def index
      @groups = Addressbook::Group.find(:all, params: { account_id: current_addressbook_account.id })
    end

    def new
      @group = Addressbook::Group.new
    end

    def create
      @group = current_addressbook_account.groups.new(group_params)

      if @group.save
        redirect_to :back, notice: t('addressbook.group.create_notice')
      else
        render :new
      end
    end

    def edit
      
    end

    def update
      if @group.update_attributes(group_params)
        redirect_to :back, notice: t('addressbook.group.update_notice')
      else
        render :edit
      end
    end

    def destroy
      @group.destroy
    end


    private

    def load_resource
      @group = Addressbook::Group.find(params[:id])
    end

    def group_params
      params.fetch(:group, {}).permit(:name, :description)
    end
  end
end
