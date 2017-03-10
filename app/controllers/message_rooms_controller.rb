class MessageRoomsController < ApplicationController

  before_action :authenticate_user!
  before_action :valid_room, only: [:new]
  before_action :correct_user, only: [:show]

  def index
    @message_rooms = current_user.message_rooms.sort_by{|mr|mr.last_updated_time}.reverse
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

    opp_user = @message_room.opp_user(current_user.id)
    @new_message  = Message.new(sender_id: current_user.id, receiver_id: opp_user.id, message_room_id: @message_room.id)

    if @message_room.last_sender_id == opp_user.id && 0 < @message_room.new_messages_count.to_i
      current_user.new_messages_count -= @message_room.new_messages_count if current_user.new_messages_count
      current_user.save
      @message_room.update_attributes(new_messages_count: 0, new_messages_exist: false)
      @message_room.messages.where(checked: false).each do |message|
        message.update_attributes(checked: true)
      end
    end
  end

  private
    def valid_room
      if !params[:user_id]
        flash[:failure] = "不正なアクセスです"
        redirect_to :top
      end
    end
    def correct_user
      mr = MessageRoom.find(params[:id])
      mid = current_user.id
      unless mid == mr.creater_id || mid == mr.created_id
        flash[:failure] = "不正なアクセスです"
        redirect_to :top
      end
    end
end
