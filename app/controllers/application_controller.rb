class ApplicationController < ActionController::Base

  helper_method :current_user, :logged_in?
  helper_method :vapid_public_key
  after_action :discard_flash_if_xhr

  # 例外をキャッチ
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e
    render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
  end


  private
  def current_user
    return unless session[:uid]
    if @current_user ||= User.where(uid: session[:uid]).order(created_at: :desc).first
      @current_user.id ||= @current_user[:id]
      cookies.encrypted[:user_id] ||= @current_user.id
      if @auth_user ||= Auth.where(user_id: @current_user.id).order(created_at: :desc).first
        @auth_user.id ||= @auth_user[:user_id]
        # @providers = Auth.where(user_id: @current_user.id).pluck(:provider)
      end

      unless controller_name == "posts" && action_name == "new" || controller_name == "posts" && action_name == "create" || controller_name == "users" && action_name == "edit" || controller_name == "users" && action_name == "update"
        if @current_user.display_name.present?
          post_count = Post.where(post_uid: @current_user.uid).count
          if post_count == 0
            flash[:error] = "まずは投稿してみましょう！"
            redirect_to new_post_path
            return
          else
            last_post = Post.where(post_uid: @current_user.uid).last
            sabun = (Date.today - last_post.created_at.to_datetime).to_i
            if sabun >= 3
              flash[:error] = "しばらく冒険の投稿がないようです。何か投稿してみましょう！"
              redirect_to new_post_path
              return
            end
          end
        else
          if @current_user.instance_title.present?
            flash[:error] = "冒険者名を決めましょう！"
            redirect_to edit_user_path(@current_user)
            return
          else
            flash[:notice] = "Mastodonからメールが届きます。確認したら冒険者名を決めましょう！"
            redirect_to edit_user_path(@current_user)
            return
          end
        end
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

  def logged_in?
    !!session[:uid]
  end

end
