class ContactsController < ApplicationController

  def index
    @circle   = Circle.find(params[:circle_id])
    @contacts = @circle.contacts
  end

  def new
    @contact = Contact.new
  end
  def create
    @contact = Contact.new(contact_params)
    @contact.send_user_id      = current_user.id
    @contact.receive_circle_id = params[:circle_id]
    if @contact.save
      flash[:success] = "送信完了"
      redirect_to @contact.receive_circle
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end
  def update
  end

  def destroy
  end

  private
    def contact_params
      params.require(:contact).permit(
          :content, :send_user_id, :receive_circle_id
        )
    end

end
