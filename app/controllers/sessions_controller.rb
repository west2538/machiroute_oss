class SessionsController < ApplicationController

  require 'date'

  def create

    if cookies.encrypted[:username].present? && cookies.encrypted[:domain].present?

      flash[:notice] = "メールアドレスの確認完了！まちかどルートにログインしましょう"
      cookies.delete(:username)
      cookies.delete(:domain)
      redirect_to root_path
      return

    else

      if params[:username]

        @mastodon_master = User.where(uid: 'townsguild@another-guild.com').order(created_at: :desc).first
        username = params[:username]
        email = params[:email]
        password = params[:password]
        agreement = params[:agreement]
        locale = params[:locale]
        params = { "username" => username, "email" => email, "password" => password, "agreement" => agreement, "locale" => locale }

        client = Mastodon::REST::Client.new(base_url: "https://another-guild.com", bearer_token: @mastodon_master.token)
        begin
          @new_user = client.create_account(params)
        rescue => e
          flash[:error] = "登録できませんでした。ユーザー名またはメールアドレスはすでに存在します"
          redirect_to root_path
          return
        end

        uid = username + '@another-guild.com'
        @user = User.find_or_create_by(uid: uid) do |user|
          user.uid = uid
          user.provider = 'mastodon'
          user.token = @new_user.access_token
        end

        session[:uid] = uid
        session[:token] = @user.token

        cookies.encrypted[:username] = username
        cookies.encrypted[:domain] = 'another-guild.com'

        flash[:notice] = "登録したメールアドレスにメールが届きます。確認のうえ、まちかどルートにログインしてください"

      else

        begin
          @user = User.find_or_create_from_auth(request.env['omniauth.auth'])
          @mastodon_auth = request.env['omniauth.auth']
          @user.token = @mastodon_auth['credentials']['token']
          @user.avatar = @mastodon_auth['extra']['raw_info']['avatar']
          @user.display_name = @mastodon_auth['extra']['raw_info']['display_name']
          @user.note = @mastodon_auth['extra']['raw_info']['note']
        rescue Exception => e
          redirect_to root_path
          return
        end
        if @user.uid.present? && @user.token.present?
          session[:uid] = @user.uid
          session[:token] = @user.token
          domain_array = @user.uid.split('@')
          domain = domain_array.last
        else
          reset_session
          redirect_to root_path
          return
        end

      end

      begin
        if @user.uid.present? && @user.token.present?

          # uri = URI.parse("https://#{domain}/api/v1/accounts/verify_credentials?bearer_token=#{access_token}")
          # json_fields = Net::HTTP.get(uri)
          # fields = JSON.parse(json_fields)
          # @user.fields1_name = fields['fields'][0]['name']
          # @user.fields2_name = fields['fields'][1]['name']
          # @user.fields3_name = fields['fields'][2]['name']
          # @user.fields4_name = fields['fields'][3]['name']
          # @user.fields1_value = fields['fields'][0]['value']
          # @user.fields2_value = fields['fields'][1]['value']
          # @user.fields3_value = fields['fields'][2]['value']
          # @user.fields4_value = fields['fields'][3]['value']

          # インスタンス名を取得
          uri = URI.parse("https://#{domain}/api/v1/instance")
          json = Net::HTTP.get(uri)
          result = JSON.parse(json)
          @user.instance_title = result['title']

          @master = User.where(uid: 'townsguild@another-guild.com').order(created_at: :desc).first
          master_token = @master.token
          follow_uid = session[:uid]
          access_token = session[:token]
          MastodonFollowJob.perform_later(domain,master_token,follow_uid,access_token)
        
          flash[:notice] = "ログイン完了！HP+10"

          if @user.machika_token == nil
          @user.machika_token = 20
          flash[:notice] = "ログインボーナス💌MaChiKa+20"
          end

          if @user.level == nil
            @user.level = 1
            @user.exp = 0
            @user.hp = 50
          else
            sabun = (Date.today - Date.parse(@user.updated_at.to_s)).to_i
            @user.hp = @user.hp - (sabun * 10)
            if @user.hp <= 0
              @user.hp = 0
              flash[:error] = "未ログインが長かったためHPを使い果たして冒険中に倒れました..。投稿画面で「復活の呪文」を唱えよう！"
            else
              @user.hp = @user.hp + 10
              if @user.hp >= ((@user.level * 2) + 68)
                @user.hp = ((@user.level * 2) + 68)
              end
            end
          end
          @user.save
          redirect_to root_path
        else
          redirect_to root_path
        end
      rescue => e
        flash[:notice] = "登録したメールアドレスにメールが届きます。確認のうえ、まちかどルートにログインしてください"
        redirect_to root_path
        return
      end

    end

  end

  # セッションを破棄/ログアウト
  def destroy

    # provider = params[:provider]
    # @auth = User.find_or_create_from_auth(request.env['omniauth.auth'])
    # auth.destroy

    # @_current_userの値をnilにする
    @current_user = nil
    # reset_session
    session[:uid] = nil
    session[:token] = nil
    cookies.delete(:user_id)
    # session[:provider] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to root_path
  end

  def failure
    flash[:notice] = "認証エラー。もう一度まちかどルートにログインしてみてください"
    redirect_to root_path
    return
  end

end