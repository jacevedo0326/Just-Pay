class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service, only: %i[ show edit update destroy ]

  def index
    @services = current_user.accessible_services
  end

  def show
  end

  def new
    @service = current_user.services.build
  end

  def edit
  end

  def create
    @service = current_user.services.build(service_params)
    
    # Set the company_owner based on the user's role
    if current_user.company_owner?
      @service.company_owner = current_user
    else
      @service.company_owner = current_user.company_owner
    end

    if @service.save
      redirect_to @service, notice: "Service was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @service.update(service_params)
      redirect_to @service, notice: "Service was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @service.destroy
    redirect_to services_url, notice: "Service was successfully destroyed."
  end

  private
    def set_service
      @service = current_user.services.find(params[:id])
    end

    def service_params
      params.require(:service).permit(:name, :price)
    end
end