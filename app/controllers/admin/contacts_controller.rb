class Admin::ContactsController < ApplicationController
  before_action :set_user, only: [:create, :destroy, :check]

  def create
    @new_contact = @user.contacts.build(comment: params[:contact][:comment], from_admin: true)
    respond_to do |format|
      if @new_contact.save
        flash[:notice] = 'お問い合わせへの返信を送信しました。'
        @user.notifications.create(contact_id: @new_contact.id, action: 0)
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

  def check
    @user.notifications.admin_notify.unchecked.update(checked: true)
    redirect_to admin_user_url(@user)
  end

  def index
    @notifications = Notification.where(to_admin: true).order(created_at: :desc).page(params[:page])
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
