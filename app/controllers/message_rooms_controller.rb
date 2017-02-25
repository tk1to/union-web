class MessageRoomsController < ApplicationController

  def new
    # if !@message_room =
    #   current_user.message_rooms.find_by(created_id: params[:user_id])||
    #   current_user.message_rooms.find_by(creater_id: params[:user_id])
    mid = current_user.id
    yid = params[:user_id].to_i
    rooms = current_user.message_rooms
    if rooms.select{|r|r.creater_id==yid||r.created_id==yid}.blank?
      @message_room = MessageRoom.new(creater_id: current_user.id, created_id: params[:user_id])
      @message_room.save
    else
      @message_room = rooms.select{|r|r.creater_id==yid||r.created_id==yid}[0]
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
