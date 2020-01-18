class Admin::ContactsController < ApplicationController
  before_action :set_user

  def create
    @new_contact = @user.contacts.build(comment: params[:contact][:comment], from_admin: true)
    respond_to do |format|
      if @new_contact.save
        flash[:notice] = 'お問い合わせへの返信を送信しました。'
        format.html { redirect_to admin_user_url(@user) }
      else
        format.js { render 'error' }
      end
    end
  end

  def destroy
    contact = Contact.find(params[:id])
    contact.destroy
    @contacts = @user.contacts.page(params[:page])
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
