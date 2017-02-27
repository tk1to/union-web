class CirclesController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show, :feed, :search]
  before_action :member_check, only: [:edit, :update, :destroy, :resign, :favorited]

  def index
    @circles = Circle.all.order("created_at DESC")
  end
  def new
    @circle = Circle.new
  end
  def create

    @circle = Circle.new(circle_params)
    if @circle.save
      flash[:success] = "作成完了"
      @membership = Membership.create(member_id: current_user.id, circle_id: @circle.id)
      redirect_to @circle
    else
      render 'new'
    end
  end

  def show
    @circle = Circle.find(params[:id])

    @members    = @circle.members.limit(5)
    @blogs      = @circle.blogs.limit(5)
    @events     = @circle.events.limit(5)
    @categories = @circle.categories

    @be_member = @members.include?(current_user)

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

    # @informations = {
    #   join_colleges: "参加大学",
    #   people_scale:  "人数(男女比)",
    #   activity_place: "活動場所",
    #   activity_frequency: "活動頻度",
    #   annual_fee: "会費",
    #   party_frequency: "飲み会頻度",
    # }

  end

  def edit
    @circle     = Circle.find(params[:id])

    @categories = @circle.categories
    @category_options = Category.all
    @category_ids = Array.new
    for i in 0..Category.max-1 do
      @category_ids[i] = @categories[i].nil? ? nil : @categories[i].id
    end
    # @informations = {
    #   join_colleges: "参加大学",
    #   people_scale:  "人数(男女比)",
    #   activity_place: "活動場所",
    #   activity_frequency: "活動頻度",
    #   annual_fee: "会費",
    #   party_frequency: "飲み会頻度",
    # }
  end
  def update
    @circle = Circle.find(params[:id])
    update_categories
    if @circle.update_attributes(circle_params)
      @circle.save
      flash[:success] = "編集完了"
      redirect_to @circle
    else
      render 'edit'
    end
  end

  def destroy
    @circle = Circle.find(params[:id])
    if params[:delete_confirmed]
      @circle.destroy
      flash[:notice] = "削除完了"
      redirect_to :root
    else
      render "delete_confirm"
    end
  end

  def resign
    @circle = Circle.find(params[:id])
    if params[:resign_confirmed]
      current_user.memberships.find_by(circle_id: params[:id]).destroy
      flash[:notice] = "退団完了"
      redirect_to :root
    else
      render "resign_confirm"
    end
  end

  def favorited
    @circle = Circle.find(params[:id])
  end

  def search
    @search_params = Circle.new
    @category_options = Category.all
    @circles = Circle.all
    if !params[:circle].nil?
      @circles = @circles.joins(:categories).where(categories: {id: params[:circle][:categories]}) if params[:circle][:categories].present?
      @circles = @circles.where(Circle.arel_table[:name].matches("%#{ params[:circle][:name] }%"))
    end
  end
  def feed
    @circles = Circle.all
    if user_signed_in? && (fed_category = current_user.categories.first).present?
      @circles = @circles.joins(:categories).where(categories: {id: fed_category.id})
    end
  end

  def members
    @circle = Circle.find(params[:id])
    @members = @circle.members
  end

  private
    def circle_params
      params.require(:circle).permit(
          :name,
          :description,
          :picture,
          :header_picture,
          :activity, :join_colleges, :people_scale,
          :activity_place, :activity_frequency,
          :annual_fee, :party_frequency,
        )
    end
    def member_check
      circle = Circle.find(params[:id])
      unless circle.members.include?(current_user)
        flash[:failure] = "メンバーのみの機能です"
        redirect_to :root
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
end
