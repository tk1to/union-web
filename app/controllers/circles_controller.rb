class CirclesController < ApplicationController

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

    @members    = @circle.members
    @blogs      = @circle.blogs
    @events     = @circle.events
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

    # 足跡
    if current_user && !@be_member
      if footed_print = @circle.footed_prints.find_by(footed_user_id: current_user.id)
        footed_print.touch
        footed_print.save
      else
        @circle.footed_prints.create(footed_user_id: current_user.id)
      end
    end

  end

  def edit
    @circle     = Circle.find(params[:id])

    @categories = @circle.categories
    @category_options = Category.all
    @category_ids = Array.new
    for i in 0..Category.max-1 do
      @category_ids[i] = @categories[i].nil? ? nil : @categories[i].id
    end
  end
  def update
    @circle = Circle.find(params[:id])
    update_categories
    if @circle.update_attributes(circle_params)
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
    if (fed_category = current_user.categories.first).present?
      # @circle_categories = CircleCategory.where(category_id: fed_category.id, priority: 0)
      # @circles = @circles.joins(:circle_categories).where(circle_categories: {category_id: fed_category.id}).where(categories: {priority: 0})
    end
  end

  def foots
    circle = Circle.find(params[:id])
    @foots = circle.footed_prints
  end

  private
    def circle_params
      params.require(:circle).permit(
          :name,
          :description,
          :picture,
          :header_picture,
        )
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
