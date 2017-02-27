class MessageRoomsController < ApplicationController

  before_action :authenticate_user!
  before_action :valid_room, only: [:new]
  before_action :correct_user, only: [:show]

  def index
    @message_rooms = current_user.message_rooms
  end
  def new
    mid = current_user.id
    yid = params[:user_id].to_i
    rooms = current_user.message_rooms
    if rooms.select{|r|r.creater_id==yid||r.created_id==yid}.blank?
      @message_room = MessageRoom.new(creater_id: current_user.id, created_id: yid)
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

  private
  def valid_room
    if !params[:user_id]
      flash[:failure] = "不正なアクセスです"
      redirect_to :root
    end
  end
  def correct_user
    mr = MessageRoom.find(params[:id])
    mid = current_user.id
    unless mid == (mr.creater_id || mr.created_id)
      flash[:failure] = "不正なアクセスです"
      redirect_to :root
    end
  end
end
