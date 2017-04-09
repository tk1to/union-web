class DebugController < ApplicationController

  before_action :env_develop, only: [:switch]
  before_action :admin_check, except: [:switch]

  def switch
    id = params[:id].to_i
    if id == 0
      sign_out
    elsif user = User.find_by(id: id)
      sign_out
      sign_in user
      flash[:notice] = "#{user.name}でログイン"
    end
    redirect_to :top
  end

  def debug
    @dummies = User.where(status: "dummy").order(:id)
    if current_user.status == "admin"
      @admin = current_user
    elsif current_user.status == "dummy"
      @admin = User.find(current_user.uid)
    end
  end
  def admin_login
    if user = User.find_by(id: params[:user_id])
      sign_out
      sign_in user
    end
    redirect_to :debug
  end
  def create_dummy
    dummy = User.new(email: create_dummy_email, password: "union188", status: "dummy")
    dummy.name = dummy.email
    if current_user.status == "admin"
      dummy.uid = current_user.id
    elsif
      dummy.uid = current_user.uid
    end
    dummy.skip_confirmation!
    dummy.save
    redirect_to :debug
  end

  private
    def env_develop
      if !Rails.env.development?
        redirect_to :top
      end
    end
    def admin_check
      if !(user_signed_in? && (current_user.status == "admin" || current_user.status == "dummy"))
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
