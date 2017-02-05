class CirclesController < ApplicationController
  def new
    @circle = Circle.new
  end

  def create
    @circle = Circle.new(circle_params)
    if @circle.save
      flash[:success] = "作成完了"
      redirect_to @circle
    else
      render 'new'
    end
  end

  def show
    @circle = Circle.find(params[:id])
  end

  private
    def circle_params
      params.require(:circle).permit(
          :name,
        )
    end
end
