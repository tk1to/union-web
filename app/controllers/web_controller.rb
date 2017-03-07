class WebController < ApplicationController

  include MemberKeyHelper

  def top
    @circles = Circle.all.order("created_at DESC").limit(5)
    @blogs   = Blog.all.order("created_at DESC").limit(5)
    @events  = Event.all.order("created_at DESC").limit(5)
  end

  # def signups
  # end
  def privacypolicy
  end

  def circle_key
    if params[:key].length == 9
      keys = params[:key].chars
      circle_id_from_key = decipher(keys[6])*1000 + decipher(keys[7])*100 + decipher(keys[2])*10 + decipher(keys[4])
      if circle = Circle.find_by(id: circle_id_from_key)
        if user_signed_in?
          circle.memberships.create(member_id: current_user.id, status: 3)
          flash[:success] = "#{circle.name}に加入しました"
          redirect_to :top
        else
          flash[:notice] = "登録後に#{circle.name}に加入されます"
          session["joining_circle_id"] = circle_id_from_key
          redirect_to [:new, :user, :registration]
          return
        end
      else
        flash[:failure] = "有効なURLではありませんでした"
        redirect_to :top
        return
      end
    else
      flash[:failure] = "有効なURLではありませんでした"
      redirect_to :top
      return
    end
  end

end
