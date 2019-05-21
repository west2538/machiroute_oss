class NotificationsController < ApplicationController
  def link_through
    @notification = Notification.find(params[:id])
    @notification.update read: true
    unless @notification.notified_type == 'mastodon'
      redirect_to post_path @notification.post
      return
    end
    redirect_to root_path
  end

  def update_all
    user = User.find_by(uid: session[:uid])
    @notification = Notification.where(user_id: user.id)
    @notification.update_all read: true
    redirect_to root_path
  end

end