class UsersController < ApplicationController

  before_action :authenticate_user!, except: [:show]
  before_action :correct_user,       only:   [:edit, :update, :destroy, :foots]

  def edit
    @user = User.find(params[:id])
    @edit_item = params[:edit_item] if params[:edit_item]
    @categories = @user.categories
    @category_options = Category.all
    @category_ids = []
    for i in 0..Category.max-1 do
      @category_ids[i] = @categories[i].nil? ? nil : @categories[i].id
    end
    @prefectures = prefectures
  end
  def update
    @user = User.find(params[:id])
    update_categories if params[:categories].present?
    if params[:user]
      if params[:college].present?
        params[:user][:college] = params[:college]
        params[:user][:faculty] = params[:faculty]
      end
      if !@user.update_attributes(user_params)
        @edit_item = params[:user][:edit_item]
        render 'edit'
        return
      end
    end
    flash[:success] = "編集完了"
    redirect_to @user
  end

  def show
    @user = User.find(params[:id])
    print_foot if user_signed_in?
    @profiles = {
      introduce: "自己紹介",
    }
    if @user.circles.any?
      @profiles.merge!({
        oppotunity:     "サークルに入ったきっかけ",
        career:         "これまでやっていたこと",
        seminar:        "所属ゼミ",
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
    @user  = current_user
    @users = @user.footed_users.reorder("foot_prints.updated_at DESC").page(params[:page]).per(25)
    foots  = @user.footed_prints.page(params[:page]).per(25)

    @checking_footed_user_ids = []
    FootPrint.record_timestamps = false
    foots.where(checked: false).each do |foot|
      foot.update_attribute(:checked, true)
      @checking_footed_user_ids << foot.footer_user_id
    end
    FootPrint.record_timestamps = true

    @user.update_attributes(new_foots_count: @user.footed_prints.where(checked: false).count)

    render "index"
  end

  def rest
    @user = User.find(params[:id])
  end

  private
    def user_params
      params.require(:user).permit(
          :name, :email, :password, :password_confirmation,
          :sex, :college, :faculty, :grade,
          :picture, :header_picture,
          :birth_place, :home_place,
          :introduce,
          :oppotunity, :career, :my_circle_atom,
          :seminar
        )
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to :top unless current_user?(@user)
    end

    def print_foot
      if !current_user?(@user)
        if footed_print = @user.footed_prints.find_by(footer_user_id: current_user.id)
          footed_print.update_attribute(:checked, false)
          @user.update_attribute(:new_foots_count, @user.footed_prints.where(checked: false).count)
        else
          @user.footed_prints.create(footer_user_id: current_user.id)
          @user.update_attribute(:new_foots_count, @user.footed_prints.where(checked: false).count)
          if @user.new_foots_count % 3 == 0
            UserMailer.notification_mail(@user, "foots", nil).deliver_now
          end
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
    def prefectures
      ["北海道", "青森県", "岩手県", "宮城県", "秋田県",
      "山形県", "福島県", "茨城県", "栃木県", "群馬県",
      "埼玉県", "千葉県", "東京都", "神奈川県", "新潟県",
      "富山県", "石川県", "福井県", "山梨県", "長野県",
      "岐阜県", "静岡県", "愛知県", "三重県", "滋賀県",
      "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県",
      "鳥取県", "島根県", "岡山県", "広島県", "山口県",
      "徳島県", "香川県", "愛媛県", "高知県", "福岡県",
      "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県",
      "鹿児島県", "沖縄県"]
    end

end
