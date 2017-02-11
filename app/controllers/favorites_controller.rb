class FavoritesController < ApplicationController

  def create
    circle = Circle.find(params[:circle_id])
    current_user.favorites.create(circle_id: circle.id)
    flash[:success] = "気になるをしました"
    redirect_to circle
  end

  def destroy
    circle = Circle.find(params[:circle_id])
    Favorite.find(params[:id]).destroy
    flash[:success] = "気になるを解除しました"
    redirect_to circle
  end
end
