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

    @members = @circle.members
    @blogs   = @circle.blogs
    @events  = @circle.events

    @be_member = @members.include?(current_user)
  end

  def edit
  end
  def update
  end

  def destroy
  end

  private
    def circle_params
      params.require(:circle).permit(
          :name,
        )
    end
end
