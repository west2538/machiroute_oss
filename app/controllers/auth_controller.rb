class AuthController < ApplicationController
  before_action :current_user

  def create
    auth = request.env["omniauth.auth"]
    uid = auth[:uid]
    provider = auth[:provider]
    session[:provider] = provider
    session[:oauth_token] = auth['credentials']['token']
    session[:oauth_token_secret] = auth['credentials']['secret']
    unless Auth.find_by_uid_and_provider(uid,provider)
      Auth.create(uid:uid, provider:provider, user_id:@current_user.id)
    end

    # 新規アカウントからマスターをフォロー
    if provider == 'twitter'
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = session[:oauth_token]
        config.access_token_secret = session[:oauth_token_secret] 
      end
      @current_user.twitter_screenname = client.user.screen_name
      @current_user.save
      follow_info = client.friendships('west2538').first
      unless session[:uid] == 'west2538@tokamstdn.jp'
        unless follow_info['connections'].include?('following') || @current_user.twitter_screenname == 'west2538'
          client.follow('west2538')
        end
      end
    end

    flash[:notice] = "#{provider}連携が完了しました！"
    redirect_to root_url
  end
 
  def destroy
    auth = Auth.find_by(user_id: @current_user.id)
    auth.destroy
    provider = session[:provider]
    session[:oauth_token] = nil
    session[:oauth_token_secret] = nil
    flash[:notice] = "#{provider}連携を解除しました！"
    redirect_to root_url
  end
end
