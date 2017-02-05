class WebController < ApplicationController

  def top
    @circles = Circle.all
  end

  def signups
  end
end
