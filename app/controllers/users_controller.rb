class UsersController < ApplicationController

  before_action :logged_in_user, only: [:edit, :update, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]

  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    ActiveRecord::Base.connection.execute("SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));")
    if @user.save
      @user.send_activation_email
      flash[:info] = "アカウントを有効にするためにメールを確認してください。"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    if params[:edit_item]
      @edit_item = params[:edit_item]
    else
      redirect_to @user
    end
  end
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @edit_item = params[:user][:edit_item]
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def following
    @header = "フォロー"
    @user  = User.find(params[:id])
    @users = @user.following
    render 'follow'
  end
  def followers
    @header = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers
    render 'follow'
  end

  private
    def user_params
      params.require(:user).permit(
          :name, :email, :password, :password_confirmation,
          :introduce, :want_to_do, :hobby,
        )
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
