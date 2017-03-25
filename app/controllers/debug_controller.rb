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
    @image = 'https://scontent.xx.fbcdn.net/v/t1.0-1/p200x200/15826577_361766737516952_3314116330811571187_n.jpg?oh=57df7ed4f7ee5ace47f3477345b6ff51&oe=5929F5FA'
  end

  private
    def env_develop
      redirect_to :top if !Rails.env.development?
    end
end
