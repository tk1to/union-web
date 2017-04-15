class ContactsController < ApplicationController

  before_action :authenticate_user!
  before_action -> { member_check(params[:circle_id]) }, only: [:index, :show]
  before_action :external_check,                         only: [:new, :create]

  def index
    @circle   = Circle.find(params[:circle_id])
    @contacts = @circle.contacts
  end

  def new
    @contact = Contact.new
  end
  def create
    @contact = Contact.new(contact_params)
    circle = Circle.find(params[:circle_id])
    if @contact.valid?
      if params[:contact][:confirmed]
        @contact.assign_attributes(send_user_id: current_user.id, receive_circle_id: circle.id)
        @contact.save
        circle.memberships.each do |ms|
          if ms.chief? || ms.admin?
            if !Notification.find_by(notification_type: 4, hold_user_id: ms.id, circle_id: circle.id, user_id: current_user.id)
              Notification.create(notification_type: 4, hold_user_id: ms.id, circle_id: circle.id, user_id: current_user.id)
              ms.member.update_attribute(:new_notifications_exist, true)
              # UserMailer.notification_mail(ms.member, "contact", [user_name: current_user.name, circle_name: circle.name]).deliver_now
            end
          end
        end
        flash[:success] = "送信完了"
        redirect_to @contact.receive_circle
      else
        render "confirm"
      end
    else
      render "new"
    end
  end

  def show
    @contact = Contact.find(params[:id])
  end
  def destroy
  end

  private
    def contact_params
      params.require(:contact).permit(
          :content, :send_user_id, :receive_circle_id
        )
    end
    def external_check
      circle = Circle.find(params[:circle_id])
      if circle.members.include?(current_user)
        flash[:alert] = "メンバーではないユーザーのみの機能です"
        redirect_to :top
      end
    end
end
