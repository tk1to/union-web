class UsersController < ApplicationController

  before_action :correct_user,   only: [:edit, :update]

  # def new
  #   @user = User.new
  # end
  # def create
  #   @user = User.new(user_params)
  #   ActiveRecord::Base.connection.execute("SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));")
  #   if @user.save
  #     @user.send_activation_email
  #     flash[:info] = "アカウントを有効にするためにメールを確認してください。"
  #     redirect_to root_url
  #   else
  #     flash.now[:error] = "エラーがあります。"
  #     render 'new'
  #   end
  # end

  def edit
    @user = User.find(params[:id])
    if params[:edit_item]
      @edit_item = params[:edit_item]
    end
  end
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "編集完了"
      redirect_to @user
    else
      @edit_item = params[:user][:edit_item]
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
    print_foot
    @profiles = {
      birth_place:  "出身地",
      home_place:   "住んでるところ",
      my_like_atom: "好きな雰囲気",
      career:       "これまでやっていたこと",
      introduce:    "自己紹介",
      want_to_do:   "大学でやりたいこと",
      hobby:        "趣味",
      future:       "将来",
    }

    # require 'net/http'
    # require 'uri'
    # require 'json'

    # uri = URI.parse('http://webservice.recruit.co.jp/shingaku/school/v2?format=json&keyword=a&key=4b0ca9238f706863')
    # json = Net::HTTP.get(uri)
    # @result = JSON.parse(json)

  end

  def destroy
    if params[:delete_confirmed]
      current_user.destroy
      flash[:notice] = "アカウント削除完了"
      redirect_to :root
    else
      render "delete_confirm"
    end
  end

  def following
    @title = "フォロー"
    @user  = User.find(params[:id])
    @users = @user.following
    render 'follow'
  end
  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers
    render 'follow'
  end
  def favorites
    @user = User.find(params[:id])
  end
  def foots
    @user = User.find(params[:id])
    @foots = @user.footed_prints
  end

  private
    def user_params
      params.require(:user).permit(
          :name, :email, :password, :password_confirmation,
          :introduce, :want_to_do, :hobby,
          :college, :department, :grade,
          :picture, :header_picture,
        )
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def print_foot
      if !current_user?(@user) && @user.circles.present?
        if footed_print = @user.footed_prints.find_by(footer_user_id: current_user.id)
          footed_print.touch
          footed_print.save
        else
          @user.footed_prints.create(footer_user_id: current_user.id)
        end
      end
    end

end
