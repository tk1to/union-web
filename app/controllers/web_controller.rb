class WebController < ApplicationController

  def top
    @circles = Circle.order("created_at DESC").limit(5)

    blog_ids = []
    before_processing = Blog.pluck(:circle_id, :id, :created_at)
    bloging_circle_ids = Blog.group(:circle_id).pluck(:circle_id)
    bloging_circle_ids.each do |n|
      this_circle_blogs = before_processing.select{|e|e[0] == n}
      blog_ids << this_circle_blogs.sort_by!{|e|e[2]}[-1][1]
    end
    @blogs = Blog.where(id: blog_ids).order("created_at DESC").limit(5)

    event_ids = []
    before_processing = Event.pluck(:circle_id, :id, :created_at)
    eventing_circle_ids = Event.group(:circle_id).pluck(:circle_id)
    eventing_circle_ids.each do |n|
      this_circle_events = before_processing.select{|e|e[0] == n}
      event_ids << this_circle_events.sort_by!{|e|e[2]}[-1][1]
    end
    @events = Event.where(id: event_ids).order("created_at DESC").limit(5)

    @ranking = Circle.order("ranking_point DESC").limit(5)
    if user_signed_in? && !current_user.tutorialed
      @tutorialing = true
      current_user.update_attribute(:tutorialed, true)
    end
    if ENV["RACK_ENV"] == "staging" || Rails.env.development?
      @tutorialing = true
    end
  end

  def landing
    redirect_to :top if user_signed_in?
    ua = request.env["HTTP_USER_AGENT"]
    unless (ua.include?('Mobile') || ua.include?('Android'))
      @desktop = true
    end
    @logining = true
  end

  def privacypolicy
  end

  def mail_form
    unless user_signed_in? && current_user.status == "admin"
      redirect_to :top
    end
  end
  def send_ad_mails
    emails = params[:ad][:emails].lines
    names  = params[:ad][:names].lines
    if emails.count == names.count
      for i in 0..emails.count-1 do
        UserMailer.ad_mail(emails[i].chomp, names[i].chomp).deliver_now
      end
      flash[:notice] = "送信完了"
    else
      flash[:alert]  = "行数違い"
    end
    redirect_to :mail_form
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
