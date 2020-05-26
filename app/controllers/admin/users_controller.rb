class Admin::UsersController < AdminController
  before_action :set_user, only: [:show, :destroy]

  def index
    @users = User.page(params[:page])
    @unckecked_notifications = Notification.admin_notify.unchecked.page(params[:page])
  end

  def show
    @contacts = @user.contacts.page(params[:page])
    @new_contact = Contact.new
  end

  def destroy; end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
