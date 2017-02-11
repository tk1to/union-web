class CirclesController < ApplicationController

  def new
    @circle = Circle.new
  end
  def create

    # circle-idのシーケンスを更新
    # ActiveRecord::Base.connection.execute("SELECT setval('circles_id_seq', (SELECT MAX(id) FROM circles));")

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

    if @entrying = @circle.entrying_users.include?(current_user)
      @entry = @circle.entries.find_by(user_id: current_user.id)
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
  end

  def search
    @search_params = Circle.new
    if params[:circle].nil?
      @circles = Circle.all
    else
      @circles = Circle.where(Circle.arel_table[:name].matches("%#{ params[:circle][:name] }%"))
    end
  end

  private
    def circle_params
      params.require(:circle).permit(
          :name,
          :description
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
          end
        else
          if !new_category_ids[i].nil?
            @circle.circle_categories.create(category_id: new_category_ids[i])
          end
        end
      end
    end
end
