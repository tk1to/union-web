class CirclesController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show, :feed, :search, :members]
  before_action :member_check, only: [:edit, :update, :destroy, :resign, :favorited, :rest]
  before_action :correct_admin, only: [:edit, :update]

  def index
    @circles = Circle.order("created_at DESC").page(params[:page]).per(15)
    if params[:category_id]
      @circles = @circles.joins(:categories).where(categories: {id: params[:category_id]})
      @title = Category.find(params[:category_id]).name
    end
    @title = params[:title] if params[:title]
  end
  def new
    @circle = Circle.new
    @category_options = Category.all
    @frequencies = [
      "週3回以上", "週2回", "週1回", "2週に1回",
      "月1回", "2か月に1回", "3か月に1回", "半年に1回", "1年に1回",
    ]
  end
  def create
    @circle = Circle.new(circle_params)

    new_category_ids = params[:categories].values.reject(&:empty?).map{|str| str.to_i}
    new_category_ids.uniq!
    if !new_category_ids.blank? && @circle.save
      flash[:success] = "作成完了"
      create_categories(new_category_ids)
      @membership = Membership.create(member_id: current_user.id, circle_id: @circle.id, status: 0)
      redirect_to @circle
    else
      @category_options = Category.all
      flash.now[:notice] = "必須項目を記入してください"
      render "new"
    end
  end

  def show
    @circle = Circle.find(params[:id])

    @members    = @circle.members.limit(5)
    @blogs      = Blog.where(circle_id: @circle.id).order("created_at DESC").limit(5)
    @events     = Event.where(circle_id: @circle.id).order("created_at DESC").limit(5)
    @categories = @circle.categories

    if @be_member = @members.include?(current_user)
      membership  = @circle.memberships.find_by(member_id: current_user.id)
      @status     = membership.status
      @status_num = membership[:status]
    end

    if user_signed_in?
      # メンバー申請しているかどうか
      if @entrying = @circle.entrying_users.include?(current_user)
        @entry = @circle.entries.find_by(user_id: current_user.id)
      end
      # 気になるをしているかどうか
      if @favoriting = current_user.favoriting_circles.include?(@circle)
        @favorite = current_user.favorites.find_by(circle_id: @circle.id)
      end
    end
    @informations = {
      joining_colleges: "参加大学",
      people_scale:  "人数",
      activity_place: "活動場所",
      annual_fee: "年会費",
      activity_frequency: "活動頻度",
      party_frequency: "飲み会頻度",
      welcome_event_schedule: "新歓日程",
    }
  end

  def edit
    @circle     = Circle.find(params[:id])

    @categories = @circle.categories
    @category_options = Category.all
    @category_ids = Array.new
    for i in 0..Category.max-1 do
      @category_ids[i] = @categories[i].nil? ? nil : @categories[i].id
    end
    @frequencies = [
      "週3回以上", "週2回", "週1回", "2週に1回",
      "月1回", "2か月に1回", "3か月に1回", "半年に1回", "1年に1回",
    ]
  end
  def update
    @circle = Circle.find(params[:id])
    update_categories
    if @circle.update_attributes(circle_params)
      @circle.save
      flash[:success] = "編集完了"
      redirect_to @circle
    else
      flash[:notice] = "必須項目が未入力です"
      redirect_to [:edit, @circle]
    end
  end

  def destroy
    @circle = Circle.find(params[:id])
    if params[:delete_confirmed]
      @circle.destroy
      flash[:success] = "削除完了"
      redirect_to :top
    else
      render "delete_confirm"
    end
  end

  def resign
    @circle = Circle.find(params[:id])
    if params[:resign_confirmed]
      current_user.memberships.find_by(circle_id: params[:id]).destroy
      flash[:success] = "退団完了"
      redirect_to :top
    else
      render "resign_confirm"
    end
  end

  def favorited
    @title = "気になるをくれたユーザー"
    @circle = Circle.find(params[:id])
    @users = @circle.favorited_users.page(params[:page]).per(25)
    render template: "users/index"
  end

  def search
    @search_params = Circle.new
    @category_options = Category.all
    @circles = Circle.all
    @frequencies = [
      "週3回以上", "週2回", "週1回", "2週に1回",
      "月1回", "2か月に1回", "3か月に1回", "半年に1回", "1年に1回",
    ]
    if !params[:circle].nil?
      @circles = @circles.joins(:categories).where(categories: {id: params[:circle][:categories]}) if params[:circle][:categories].present?

      if !params[:circle][:free_word].blank?
        free_word_name        = Circle.arel_table[:name]
        free_word_description = Circle.arel_table[:description]
        @circles = @circles.where(free_word_name.matches("%#{ params[:circle][:free_word] }%")
                              .or(free_word_description.matches("%#{ params[:circle][:free_word] }%")))
      end

      if !params[:circle][:people_scale].blank?
        ps        = params[:circle][:people_scale]
        ps_min    = ps.split("/")[0].to_i
        ps_max    = ps.split("/")[1].to_i
        psa       = Circle.arel_table[:people_scale]
        psa_query = ps_max == 0 ? psa.gteq(ps_min) : psa.gteq(ps_min).and(psa.lt(ps_max))
        @circles = @circles.where(psa_query)
      end
      if !params[:circle][:annual_fee].blank?
        af        = params[:circle][:annual_fee]
        af_min    = af.split("/")[0].to_i
        af_max    = af.split("/")[1].to_i
        afa       = Circle.arel_table[:annual_fee]
        afa_query = af_max == 0 ? afa.gteq(af_min) : afa.gteq(af_min).and(afa.lt(af_max))
        @circles = @circles.where(afa_query)
      end

      if !params[:circle][:activity_frequency].blank?
        @circles = @circles.where(activity_frequency: params[:circle][:activity_frequency])
      end
      if !params[:circle][:party_frequency].blank?
        @circles = @circles.where(party_frequency: params[:circle][:party_frequency])
      end
    end
    @circles = @circles.page(params[:page]).per(15)
    render "index"
  end
  def feed
    @circles = Circle.order("created_at DESC").page(params[:page]).per(15)
    # if user_signed_in? && (fed_category = current_user.categories.first).present?
    #   @circles = @circles.joins(:categories).where(categories: {id: fed_category.id})
    # end
    render "index"
  end

  def members
    @title = "メンバー一覧"
    circle = Circle.find(params[:id])
    @users = circle.members.page(params[:page]).per(25)
    render template: "users/index"
  end

  def rest
    @circle = Circle.find(params[:id])
    membership  = @circle.memberships.find_by(member_id: current_user.id)
    @status     = membership.status
  end

  def add_college
    @circle = Circle.find(params[:id])
    @circle.joining_college_list.add(params[:college_name])
    @circle.save
    render partial: "circles/joining_college", locals: {college: params[:college_name]}
  end
  def remove_college
    @circle = Circle.find(params[:id])
    @circle.joining_college_list.remove(params[:college_name])
    @circle.save
    render partial: "shared/none"
  end

  private
    def circle_params
      params.require(:circle).permit(
          :name, :description, :picture, :header_picture,
          :joining_colleges, :people_scale, :activity_place,
          :activity_frequency, :annual_fee, :party_frequency,
        )
    end
    def member_check
      circle = Circle.find(params[:id])
      unless circle.members.include?(current_user)
        flash[:alert] = "メンバーのみの機能です"
        redirect_to :top
      end
    end

    def correct_admin
      circle = Circle.find(params[:id])
      ms = current_user.memberships.find_by(circle_id: circle.id)
      if ms.blank?
        flash[:alert] = "サークルメンバーのみの機能です"
        redirect_to :top
      elsif ms[:status] > 1
        flash[:alert] = "管理者のみの機能です"
        redirect_to circle
      end
    end

    def update_categories
      new_category_ids = params[:categories].values.reject(&:empty?).map{|str| str.to_i}
      new_category_ids.uniq!
      category_ids = @circle.circle_categories
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
            @circle.circle_categories.create(category_id: new_category_ids[i], priority: i)
          end
        end
      end
    end
    def create_categories(ids)
      for i in 0..Category.max-1 do
        @circle.circle_categories.create(category_id: ids[i], priority: i)
      end
    end
end
