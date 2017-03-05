class FavoritesController < ApplicationController

  before_action :authenticate_user!

  def create
    @circle = Circle.find(params[:circle_id])
    current_user.favorites.create(circle_id: @circle.id)
    respond_to do |format|
      format.html { redirect_to :top }
      format.js
    end
  end

  def destroy
    @circle = Circle.find(params[:circle_id])
    Favorite.find_by(circle_id: params[:circle_id], user_id: current_user.id).destroy
    respond_to do |format|
      format.html { redirect_to :top }
      format.js
    end
  end
end
