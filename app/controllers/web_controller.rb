class WebController < ApplicationController

  def top
    @circles = Circle.all
    @blogs   = Blog.all
    @events  = Event.all
  end

  def signups
  end
end
