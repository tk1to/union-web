class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
    if session[:joining_circle_id]
      circle = Circle.find_by(id: session[:joining_circle_id])
      if circle
        if circle.memberships.find_by(member_id: resource.id)
          flash[:notice] = "既に#{circle.name}のメンバーです"
        else
          flash[:success] = "#{circle.name}に加入されました"
          resource.memberships.create(circle_id: session[:joining_circle_id])
        end
      else
        flash[:failure] = "無効なURLです"
      end
      session.delete(:joining_circle_id)
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
