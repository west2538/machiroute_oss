class NotificationsController < ApplicationController

  before_action :current_user

  def link_through
    @notification = Notification.find(params[:id])
    @notification.update read: true
    unless @notification.notified_type == 'mastodon'
      redirect_to post_path @notification.post
      return
    end
    respond_to do |format|
      format.js { @current_user }
    end
    # redirect_to root_path
  end

  def update_all
    @notification = Notification.where(user_id: @current_user.id)
    @notification.update_all read: true
    respond_to do |format|
      format.js { @current_user }
    end
    # redirect_to root_path
  end

end