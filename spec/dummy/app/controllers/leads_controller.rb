class LeadsController < ApplicationController

  load_and_authorize_resource :lead, except: [:create], through: :current_company
  authorize_resource :lead, only: [:create], through: :current_company

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @lead = current_company.leads.new(safe_params)

    if @lead.save
      redirect_to @lead, notice: 'Lead was successfully created.'
    else
      render :new
    end
  end

  def update
    if @lead.update(safe_params)
      redirect_to @lead, notice: 'Lead was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @lead.destroy
    redirect_to leads_url, notice: 'Lead was successfully removed.'
  end

  private

  def safe_params
    safe_attributes = [:name, :assignable_id]
    params.require(:lead).permit(safe_attributes)
  end

end
