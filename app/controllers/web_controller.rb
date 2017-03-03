class WebController < ApplicationController

  include MemberKeyHelper

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
    if params[:key].length == 9
      keys = params[:key].chars
      circle_id_from_key = decipher(keys[6])*1000 + decipher(keys[7])*100 + decipher(keys[2])*10 + decipher(keys[4])
      session["joining_circle_id"] = circle_id_from_key
      redirect_to [:new, :user, :registration]
    else
    end
  end
end
