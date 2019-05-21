class ApplicationController < ActionController::Base

  helper_method :current_user
  helper_method :vapid_public_key
  after_action :discard_flash_if_xhr

  private
  def current_user
    if User.find_by(uid: session[:uid])
      @current_user ||= User.where(uid: session[:uid]).order(created_at: :desc).first
      @current_user.id = @current_user[:id]
      cookies.encrypted[:user_id] = @current_user.id
      if Auth.find_by(user_id: @current_user.id)
        @auth_user ||= Auth.where(user_id: @current_user.id).order(created_at: :desc).first
        @auth_user.id = @auth_user[:user_id]
        # @providers = Auth.where(user_id: @current_user.id).pluck(:provider)
      end
    end
  end

  protected
  def discard_flash_if_xhr
    flash.discard if request.xhr?
  end

    # 現在のユーザーを取得する
    # @_current_userが空の場合は、session情報をキーにしてDBから検索する
    # def current_user
      # @_current_user ||= User.find(session[:uid])
    # end

  def vapid_public_key
    @decoded_vapid_public_key ||= Base64.urlsafe_decode64(ENV['VAPID_PUBLIC_KEY']).bytes
  end

end
