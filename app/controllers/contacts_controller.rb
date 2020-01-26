class ContactsController < ApplicationController
  before_action :logged_in_user

  def index
    @contacts = current_user.contacts.page(params[:page]).per(6)
    @new_contact = Contact.new
    current_user.notifications.user_notify.update(checked: true)
  end

  def create
    @new_contact = current_user.contacts.build(contact_params)
    respond_to do |format|
      if @new_contact.save
        flash[:notice] = 'お問い合わせ内容を送信しました。'
        current_user.notifications.create(contact_id: @new_contact.id, to_admin: true)
        current_user.send_notification_email(@new_contact)
        format.html { redirect_to contacts_url }
      else
        format.js { render 'error' }
      end
    end
  end

  def destroy
    contact = Contact.find(params[:id])
    contact.destroy
    @contacts = current_user.contacts.page(params[:page]).per(6)
  end

  private

  def contact_params
    params.require(:contact).permit(:comment)
  end
end
