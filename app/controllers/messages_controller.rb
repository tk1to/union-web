class MessagesController < ApplicationController

  before_action :authenticate_user!

  def create
    message = Message.new(message_params)
    message.save
    @message_room = MessageRoom.find(message.message_room_id)

    # message.receiver.update_attribute(:new_messages_exist, true)
    # @message_room.update_attribute(:new_messages_exist, true)

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