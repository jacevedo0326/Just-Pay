module Company
  class WorkersController < ApplicationController
    before_action :authenticate_user!
    before_action :require_company_owner
    before_action :set_worker, only: [:show, :edit, :update, :destroy, :remove]
    
    def index
      @pending_requests = current_user.worker_requests.pending
      @workers = current_user.workers
    end

    def show
    end

    def edit
    end

    def update
      if @worker.update(worker_params)
        redirect_to company_workers_path, notice: 'Worker was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @worker.destroy
      redirect_to company_workers_path, notice: 'Worker was successfully removed.'
    end

    def approve_request
      @request = current_user.worker_requests.find(params[:id])
      @worker = @request.worker
      
      ActiveRecord::Base.transaction do
        @request.update!(status: 'accepted')
        @worker.update!(company_owner: current_user)
      end
      
      redirect_to company_workers_path, notice: 'Worker request approved'
    rescue ActiveRecord::RecordNotFound
      redirect_to company_workers_path, alert: 'Request not found'
    end

    def reject_request
      @request = current_user.worker_requests.find(params[:id])
      @request.update!(status: 'rejected')
      redirect_to company_workers_path, notice: 'Worker request rejected'
    rescue ActiveRecord::RecordNotFound
      redirect_to company_workers_path, alert: 'Request not found'
    end

    def remove
      @worker.update!(company_owner: nil)
      redirect_to company_workers_path, notice: 'Worker removed from company'
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
        redirect_to root_path, alert: 'Access denied. Company owner privileges required.'
      end
    end
  end
end