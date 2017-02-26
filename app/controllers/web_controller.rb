class WebController < ApplicationController

  def top
    @circles = Circle.all.order("created_at DESC")
    @blogs   = Blog.all
    @events  = Event.all
  end

  def signups
  end
end
