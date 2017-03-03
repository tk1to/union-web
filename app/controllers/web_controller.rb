class WebController < ApplicationController

  def top
    @circles = Circle.all.order("created_at DESC").limit(5)
    @blogs   = Blog.all.limit(5)
    @events  = Event.all.limit(5)
  end

  def signups
  end
  def privacypolicy
  end

  def circle_key
    # session["circle_id"] = params[:key]
    redirect_to [:new, :user, :registration]
  end
end
