class ContactsController < ApplicationController
  before_action :logged_in_user

  def index
    @contacts = current_user.contacts
    @new_contact = Contact.new
  end

  def create
    @new_contact = current_user.contacts.build(contact_params)
    respond_to do |format|
      if @new_contact.save
        flash[:notice] = 'お問い合わせ内容を送信しました。'
        format.html { redirect_to contacts_url }
      else
        format.js { render 'error' }
      end
    end
  end

  def destroy
  end

  private

  def contact_params
    params.require(:contact).permit(:comment)
  end
end
