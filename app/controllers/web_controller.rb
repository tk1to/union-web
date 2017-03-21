class WebController < ApplicationController

  def top
    @circles = Circle.all.order("created_at DESC").limit(5)
    @blogs   = Blog.all.order("created_at DESC").limit(5)
    @events  = Event.all.order("created_at DESC").limit(5)
    if user_signed_in? && !current_user.tutorialed
      @tutorialing = true
      current_user.update_attribute(:tutorialed, true)
    end
    if ENV["RACK_ENV"] == "staging" || Rails.env.development?
      @tutorialing = true
    end
    if ENV["RACK_ENV"] == "production"
      @tutorialing = false
    end

    @yume_award = Circle.find_by(id: 2)
    @jagzzi     = Circle.find_by(id: 4)
    @sal        = Circle.find_by(id: 6)
  end

  def landing
    redirect_to :top if user_signed_in?
    ua = request.env["HTTP_USER_AGENT"]
    unless (ua.include?('Mobile') || ua.include?('Android'))
      @desktop = true
    end
  end

  def privacypolicy
  end

  def letsencrypt
    if params[:id] == ENV["LETSENCRYPT_REQUEST"]
    render text: ENV["LETSENCRYPT_RESPONSE"]
    end
  end

  include MemberKeyHelper
    def circle_key
      if params[:key].length == 9
        keys = params[:key].chars
        circle_id_from_key = deciph(keys)
        if circle = Circle.find_by(id: circle_id_from_key)
          if user_signed_in?
            if !circle.memberships.find_by(member_id: current_user)
              circle.memberships.create(member_id: current_user.id, status: 3)
              flash[:success] = "#{circle.name}に加入しました"
            else
              flash[:success] = "既に#{circle.name}のメンバーです"
            end
            redirect_to :top
          else
            flash[:notice] = "登録またはログイン後に#{circle.name}に加入されます"
            session["joining_circle_id"] = circle_id_from_key
            redirect_to [:new, :user, :registration]
            return
          end
        else
          flash[:alert] = "有効なURLではありませんでした"
          redirect_to :top
          return
        end
      else
        flash[:alert] = "有効なURLではありませんでした"
        redirect_to :top
        return
      end
    end

end
