class MessageRoomsController < ApplicationController

  def new
    if !@message_room =
      current_user.message_rooms.find_by(created_id: params[:created_id])||
      current_user.message_rooms.find_by(creater_id: params[:created_id])

      MessageRoom.create(creater_id: current_user.id, created_id: params[:created_id])
    end
    redirect_to @message_room
  end

  def show
    @message_room = MessageRoom.find(params[:id])
    @messages     = @message_room.messages

    opponent_id   = @message_room.creater_id == current_user.id ? @message_room.created_id : @message_room.creater_id
    @new_message  = Message.new(sender_id: current_user.id, receiver_id: opponent_id, message_room_id: @message_room.id)
  end
end
