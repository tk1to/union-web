class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    super
    if session[:joining_circle_id]
      resource.memberships.create(circle_id: session[:joining_circle_id])
      session.delete(:joining_circle_id)
    end
  end

  # protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    # super(resource_name)
    :top
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    # super(resource_name, resource)
    sign_in(resource)
    :top
  end
end
