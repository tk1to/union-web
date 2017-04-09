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
    @dummies = User.where(status: "dummy")
  end
  def create_dummy
    dummy = User.new(email: create_dummy_email, password: "union188", status: "dummy")
    dummy.name = dummy.email
    dummy.skip_confirmation!
    dummy.save
    dummy.update_attributes(email: "no." + dummy.id.to_s + "@union.com")
    redirect_to :debug
  end

  private
    def env_develop
      if !Rails.env.development? && !(user_signed_in? && current_user.status == "admin")
        redirect_to :top
      end
    end
    def create_dummy_email
      email_string = ""
      11.times do |i|
        if i == 3
          email_string += "@"
        elsif i == 7
          email_string += "."
        else
          email_string += get_random_alphabet
        end
      end
      email_string
    end
    def get_random_alphabet
      n = rand(26)
      ("a".."z").to_a[n] || n.to_s
    end
end
