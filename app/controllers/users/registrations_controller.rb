class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def create
    build_resource(sign_up_params)

    if resource.worker? && params[:joining_company_code].present?
      company_owner = User.find_by(company_code: params[:joining_company_code])
      
      if company_owner
        # Temporarily set company_owner to allow validation to pass
        resource.company_owner = company_owner
        
        if resource.save
          WorkerRequest.create!(
            worker: resource,
            company_owner: company_owner,
            status: 'pending'
          )
          
          # Remove company_owner until request is approved
          resource.update_column(:company_owner_id, nil)
          
          # Changed to use flash directly instead of devise translation
          flash[:notice] = "Signed up successfully. Waiting for company owner approval."
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          clean_up_passwords resource
          set_minimum_password_length
          respond_with resource
        end
      else
        resource.errors.add(:base, "Invalid company code")
        clean_up_passwords resource
        set_minimum_password_length
        render :new
      end
    else
      super
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end

  def after_sign_up_path_for(resource)
    if resource.worker?
      root_path
    else
      super
    end
  end
end