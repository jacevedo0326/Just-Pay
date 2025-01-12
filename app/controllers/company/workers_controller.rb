module Company
  class WorkersController < ApplicationController
    before_action :authenticate_user!
    before_action :require_company_owner
    before_action :set_worker, only: [:show, :edit, :update, :destroy]

    def index
      @workers = current_user.workers
    end

    def show
    end

    def edit
    end

    def update
      if @worker.update(worker_params)
        redirect_to company_worker_path(@worker), notice: 'Worker was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @worker.destroy
      redirect_to company_workers_path, notice: 'Worker was successfully removed.'
    end

    private

    def set_worker
      @worker = current_user.workers.find(params[:id])
    end

    def worker_params
      params.require(:user).permit(:email)
    end

    def require_company_owner
      unless current_user.company_owner?
        redirect_to root_path, alert: 'You must be a company owner to access this area.'
      end
    end
  end
end