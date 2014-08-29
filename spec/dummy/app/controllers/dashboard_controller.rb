class DashboardController < ApplicationController

  def index
    authorize! :index, :dashboard
  end

  def unauthorized
  end

end
