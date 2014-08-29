require_dependency "blokade/application_controller"

module Blokade
  class PermissionsController < ApplicationController
    before_action :load_permission, only: [:show, :edit, :update, :destroy]

    def index
      @permissions = Permission.ordered
      @frontend_permissions = @permissions.frontend
      @backend_permissions = @permissions.backend
      @symbolic_frontend_permissions = @frontend_permissions.symbolic
      @symbolic_backend_permissions = @backend_permissions.symbolic
      @frontend_permission_subject_classes = @frontend_permissions.not_symbolic.group(:subject_class).pluck(:subject_class)
      @backend_permission_subject_classes = @backend_permissions.not_symbolic.group(:subject_class).pluck(:subject_class)
    end

    def show
    end

    def new
      @permission = Permission.new
    end

    def edit
    end

    def create
      @permission = Permission.new(safe_params)

      if @permission.save
        redirect_to @permission, notice: 'Permission was successfully created.'
      else
        render :new
      end
    end

    def update
      if @permission.update(safe_params)
        redirect_to @permission, notice: 'Permission was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @permission.destroy
      redirect_to permissions_url, notice: 'Permission was successfully removed.'
    end

    private

    def load_permission
      @permission = Permission.find(params[:id])
    end

    def safe_params
      safe_attributes = [:action, :subject_class, :description, :backend, :enable_restrictions]
      params.require(:permission).permit(safe_attributes)
    end

  end
end
