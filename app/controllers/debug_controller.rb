class DebugController < ApplicationController
  before_action :env_develop
  def switch
    id = params[:id].to_i
    if id == 0
      redirect_to [:destroy, :user, :session]
      return
    elsif user = User.find_by(id: id)
      sign_out
      sign_in user
      flash[:notice] = "#{user.name}でログイン"
    end
    redirect_to :top
  end

  def debug
  end
  def create_dummy
    
  end

  private
    def env_develop
      if !Rails.env.development? && !(user_signed_in? && current_user.status == "admin")
        redirect_to :top
      end
    end
end
