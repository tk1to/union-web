class MessageRoomsController < ApplicationController

  before_action :authenticate_user!
  before_action :valid_room, only: [:new]
  before_action :correct_user, only: [:show]

  def index
    @message_rooms = current_user.message_rooms.page(params[:page]).per(25)
  end
  def new
    yid = params[:user_id].to_i
    creater = MessageRoom.arel_table[:creater_id]
    created = MessageRoom.arel_table[:created_id]
    if (room = current_user.message_rooms.where(creater.eq(yid).or(created.eq(yid)))).blank?
      @message_room = MessageRoom.create(creater_id: current_user.id, created_id: yid, last_updated_time: DateTime.now)
    else
      @message_room = room
    end
    redirect_to @message_room
  end

  def show
    @message_room = MessageRoom.find(params[:id])

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

    @messages = @message_room.messages.order(created_at: :asc)
  end

  private
    def valid_room
      if !params[:user_id]
        flash[:alert] = "不正なアクセスです"
        redirect_to :top
      end
    end
    def correct_user
      mr = MessageRoom.find(params[:id])
      mid = current_user.id
      unless mid == mr.creater_id || mid == mr.created_id
        flash[:alert] = "不正なアクセスです"
        redirect_to :top
      end
    end
end
