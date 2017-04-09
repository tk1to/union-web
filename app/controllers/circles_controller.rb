class CirclesController < ApplicationController

  before_action :authenticate_user!,                       except: [:index, :show, :feed, :search, :members]
  before_action -> { member_check(params[:id]) },          only: [:edit, :update, :destroy, :resign, :favorited, :rest]
  before_action -> { status_check(params[:id], "admin") }, only: [:edit, :update, :favorited]
  before_action -> { status_check(params[:id], "chief") }, only: [:destroy]

  def index
    if params[:category_id]
      @circles = Circle.joins(:categories).where(categories: {id: params[:category_id]}).order("ranking_point DESC").page(params[:page]).per(15)
      if @circles.blank?
        @circles = Circle.order("ranking_point DESC").page(params[:page]).per(15)
        @title = "選択したカテゴリーの団体はありません"
      end
    elsif params[:ranking]
      @circles  = Circle.where(Circle.arel_table[:ranking_point].gt(0)).order("ranking_point DESC").page(params[:page]).per(15)
    elsif params[:news]
      @circles = Circle.order("created_at DESC").page(params[:page]).per(15)
    else
      @circles = Circle.order("ranking_point DESC").page(params[:page]).per(15)
    end
    @title = Category.find(params[:category_id]).name if params[:category_id]
    @title = params[:title]                           if params[:title]
  end
  def show
    @circle = Circle.find(params[:id])

    @members    = @circle.members.eager_load(:memberships).order("memberships.status", :id).limit(5)
    @blogs      = @circle.blogs.order("created_at DESC").limit(5)
    @events     = @circle.events.order("created_at DESC").limit(5)
    @categories = @circle.categories

    if user_signed_in?

      @membership = @circle.find_membership(current_user)

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
      org_type: "団体形態",
      people_scale:  "人数",
      activity_place: "活動場所",
      annual_fee: "年会費",
      activity_frequency: "活動頻度",
      party_frequency: "飲み会頻度",
      welcome_event_schedule: "新歓日程",
    }
  end

  def new
    @circle = Circle.new
    before_information
    @new = true
    @submit_label = "作成"
    @title        = "団体作成"
    render "form"
  end
  def edit
    @circle = Circle.find(params[:id])
    before_information
    @submit_label = "更新"
    @title        = "プロフィール編集"
    render "form"
  end

  def create
    @circle = Circle.new(circle_params)
    if circle_valid?
      updates
      membership = Membership.create(member_id: current_user.id, circle_id: @circle.id, status: 0)
      flash[:success] = "作成完了"
      redirect_to @circle
    else
      before_information
      @new = true
      flash[:notice] = "必須項目が未入力です"
      render "form"
    end
  end
  def update
    @circle = Circle.find(params[:id])
    @circle.assign_attributes(circle_params)
    if circle_valid?
      updates
      flash[:success] = "編集完了"
      redirect_to @circle
    else
      before_information
      flash[:notice] = "必須項目が未入力です"
      render "form"
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
    @circles = Circle.all
    before_information
    if !params[:circle].nil?
      @circles = @circles.joins(:categories).where(categories: {id: params[:circle][:categories]}) if params[:circle][:categories].present?

      if !params[:circle][:college].blank?
        @circles = @circles.tagged_with(params[:circle][:college])
      end

      if !params[:circle][:org_type].blank?
        @circles = @circles.where(org_type: params[:circle][:org_type])
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

      if !params[:circle][:free_word].blank?
        free_word_name        = Circle.arel_table[:name]
        free_word_description = Circle.arel_table[:description]
        @circles = @circles.where(free_word_name.matches("%#{ params[:circle][:free_word] }%")
                              .or(free_word_description.matches("%#{ params[:circle][:free_word] }%")))
      end

      wesa      = WelcomeEventSchedule.arel_table[:schedule]
      from_date = Date.new(params[:circle]["schedule_from(1i)"].to_i, params[:circle]["schedule_from(2i)"].to_i, params[:circle]["schedule_from(3i)"].to_i)
      to_date   = Date.new(params[:circle]["schedule_to(1i)"].to_i,   params[:circle]["schedule_to(2i)"].to_i,   params[:circle]["schedule_to(3i)"].to_i)
      if !(from_date == Date.new(2017,1,1) && to_date == Date.new(2017,12,31))
        @circles  = @circles.joins(:welcome_event_schedules).where(wesa.gteq(from_date).and(wesa.lteq(to_date))).uniq
      end
    end
    @circles = @circles.order("ranking_point DESC").page(params[:page]).per(15)
    render "index"
  end
  def feed
    @circles = Circle.order("ranking_point DESC").page(params[:page]).per(15)
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

  def update_ranking
    circles = Circle.all
    total   = circles.count
    circles.each_with_index do |c, i|
      point = 0
      point += c.blogs.count * 30
      point += c.events.count * 30
      point += c.members.count * 30
      point += 50*(total-i)/total
      if c.id == 1
        point = -1
      end
      c.update_attribute(:ranking_point, point)
    end
    redirect_to :top
  end

  private
    def circle_params
      params.require(:circle).permit(
          :name, :description, :picture, :header_picture,
          :org_type,
          :joining_colleges, :people_scale, :activity_place,
          :activity_frequency, :annual_fee, :party_frequency,
        )
    end
    def circle_valid?
      params[:categories].values.reject(&:empty?).present? && params[:joining_colleges].present? && @circle.valid?
    end

    def before_information
      @category_options = Category.all
      @category_ids = @circle.categories.ids if @circle
      @frequencies = [
        "週3回以上", "週2回", "週1回", "2週に1回",
        "月1回", "2か月に1回", "3か月に1回", "半年に1回", "1年に1回",
      ]
      @types = ["学内", "インカレ", "学生団体", "部活"]
    end

    def updates
      @circle.save
      update_categories
      update_joining_colleges if params[:exist_colleges_changed]
      update_schedules
    end
    def update_categories
      new_category_ids = params[:categories].values.reject(&:empty?).map{|str| str.to_i}.uniq
      category_ids = @circle.circle_categories.pluck(:category_id)
      if new_category_ids != category_ids
        @circle.circle_categories.each{|cc|cc.destroy}
        new_category_ids.each_with_index do |nc, i|
          @circle.circle_categories.create(category_id: nc, priority: i)
        end
      end
    end
    def update_joining_colleges
      @circle.joining_college_list.clear
      params[:joining_colleges].each do |jc|
        @circle.joining_college_list.add(jc)
      end
      @circle.save
    end
    def update_schedules
      if params[:exist_schedule_changed]
        @circle.welcome_event_schedules.each{|s|s.destroy}
        if !params[:schedules].blank?
          schedules = params[:schedules].sort
          schedules.each do |s|
            year  = s.split("/")[0].to_i
            month = s.split("/")[1].to_i
            day   = s.split("/")[2].to_i
            @circle.welcome_event_schedules.create(schedule: Date.new(year, month, day))
          end
        end
      end
    end
end
