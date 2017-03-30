class MessagesController < ApplicationController

  before_action :authenticate_user!

  def create
    message = Message.new(message_params)
    @message_room = MessageRoom.find(message.message_room_id)
    if message.save
      message.receiver.update_attribute(:new_messages_exist, true)
      @message_room.update_attributes(new_messages_exist: true, last_sender_id: current_user.id, last_updated_time: DateTime.now)
      UserMailer.notification_mail(message.receiver, "new_message", current_user).deliver_now
    end

    redirect_to @message_room
  end

  private
    def message_params
      params.require(:message).permit(
          :content,
          :sender_id, :receiver_id,
          :message_room_id,
        )
    end
end