class UsersController < ApplicationController

  before_action :authenticate_user!, except: [:show]
  before_action :correct_user,       only:   [:edit, :update, :destroy, :foots]

  def edit
    @user = User.find(params[:id])
    if params[:edit_item]
      @edit_item = params[:edit_item]
      if @edit_item == "categories"
        @categories = @user.categories
        @category_options = Category.all
        @category_ids = Array.new
        for i in 0..Category.max-1 do
          @category_ids[i] = @categories[i].nil? ? nil : @categories[i].id
        end
      end
    end
  end
  def update
    @user = User.find(params[:id])
    if params[:categories].present?
      update_categories
      flash[:success] = "編集完了"
      redirect_to @user
    else
      if @user.update_attributes(user_params)
        flash[:success] = "編集完了"
        redirect_to @user
      else
        @edit_item = params[:user][:edit_item]
        render 'edit'
      end
    end
  end

  def show
    @user = User.find(params[:id])
    print_foot if user_signed_in?
    @profiles = {
      birth_place:    "出身地",
      home_place:     "住んでるところ",
      categories:     "興味のあるカテゴリー",
      introduce:      "自己紹介",
    }
    if @user.circles.any?
      @profiles.merge!({
        oppotunity:     "サークルに入ったきっかけ",
        career:         "これまでやっていたこと",
        my_circle_atom: "サークルの雰囲気",
      })
    end
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
    @users = @user.following.page(params[:page]).per(25)
    render "index"
  end
  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(25)
    render "index"
  end
  def favorites
    @user = User.find(params[:id])
  end
  def foots
    @title = "足跡"
    @user = current_user
    @users = @user.footed_users.order("updated_at DESC").page(params[:page]).per(25)
    @foots = @user.footed_prints

    @user.update_attributes(new_foots_exist: false, new_foots_count: 0)
    @foots.where(checked: false).each do |foot|
      foot.update_attribute(:checked, true)
    end

    render "index"
  end

  def rest
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(
          :name, :email, :password, :password_confirmation,
          :sex, :college, :department, :grade,
          :picture, :header_picture,
          :birth_place, :home_place,
          :introduce,
          :oppotunity, :career, :my_circle_atom,
        )
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to :top unless current_user?(@user)
    end

    def print_foot
      if !current_user?(@user)
        if footed_print = @user.footed_prints.find_by(footer_user_id: current_user.id)
          footed_print.touch
          footed_print.save
        else
          @user.footed_prints.create(footer_user_id: current_user.id)
          @user.update_attribute(:new_foots_exist, true)
        end
      end
    end

    def update_categories
      new_category_ids = params[:categories].values.reject(&:empty?).map{|str| str.to_i}
      new_category_ids.uniq!
      category_ids = @user.user_categories
      for i in 0..Category.max-1 do
        if !category_ids[i].nil?
          if new_category_ids[i].nil?
            category_ids[i].destroy
          else
            category_ids[i].update_attribute(:category_id, new_category_ids[i])
            category_ids[i].update_attribute(:priority,    i)
          end
        else
          if !new_category_ids[i].nil?
            @user.user_categories.create(category_id: new_category_ids[i], priority: i)
          end
        end
      end
    end

end
