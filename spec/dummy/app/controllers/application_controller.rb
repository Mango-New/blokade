class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper Blokade::ApplicationHelper
  helper Blokade::BootstrapFlashHelper

  # What CanCan should do when a user is unauthorized
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = 'Not authorized!'
    redirect_to unauthorized_path
  end

  private

  def current_company
    @current_company = Company.first
  end

  def current_user
    @current_user = current_company.users.first
  end

  def current_ability
    current_user.ability
  end

end
