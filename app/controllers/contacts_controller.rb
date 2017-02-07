class ContactsController < ApplicationController

  def index
  end

  def new
    @contact = Contact.new
  end
  def create
    @contact = Contact.new
    if @contact.update_attributes(contact_params)
      flash[:success] = "送信完了"
      redirect_to @event
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
