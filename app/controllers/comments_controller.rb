class CommentsController < ApplicationController

    before_action :current_user
    after_action :notifications, only: [:create]

def create

    if comment_params[:image] != nil
        uploaded_file = comment_params[:image]
        output_path = Rails.root.join('public', uploaded_file.original_filename)
        img = MiniMagick::Image.read(uploaded_file)
        img.resize "240x300"
        img.write output_path
        image_file = File.open(output_path)

        image_annotator = Google::Cloud::Vision::ImageAnnotator.new
        response = image_annotator.safe_search_detection image: image_file
        response.responses.each do |res|
        safe_search = res.safe_search_annotation
            if safe_search.adult.to_s == "VERY_LIKELY" || safe_search.adult.to_s == "LIKELY"
                flash[:error] = "不適切な画像と判断されました powered by Google Cloud Vision"
                redirect_to root_path
                return
            elsif safe_search.violence.to_s == 'VERY_LIKELY' || safe_search.violence.to_s == 'LIKELY'
                flash[:error] = "不適切な画像と判断されました powered by Google Cloud Vision"
                redirect_to root_path
                return
            elsif safe_search.medical.to_s == 'VERY_LIKELY' || safe_search.medical.to_s == 'LIKELY'
                flash[:error] = "不適切な画像と判断されました powered by Google Cloud Vision"
                redirect_to root_path
                return
            end
        end
        File.delete(output_path)
    end
    
    params[:comment][:user_uid] = session[:uid]
    questbody = params[:comment][:body]
    @post = Post.find(params[:post_id])

    if questbody.size <= 3 || questbody.size > 300 
        flash.now[:error] = "クリアコメントは4～300文字で！"
    else
        @comment = @post.comments.create(comment_params)
        comment_status = questbody + "\n\n#サブクエストをクリア\n" + "┏┿────────────\n" + @post.body.truncate(17) + "\n─────────────┿┛\n" + "https://machiroute.herokuapp.com" + post_path(@post)
        access_token = session[:token]
        domain_array = @current_user.uid.split('@')
        domain = domain_array.last
        MastodonCleartootJob.perform_later(domain,access_token,comment_status,@comment)

        @current_user.exp = @current_user.exp + 30
        @current_user.hp = @current_user.hp + 10
        if @current_user.exp >= (@current_user.level * 100)
            flash.now[:notice] = "🎉クリア＆レベルアップ✨"
            @current_user.level = @current_user.level + 1
            @current_user.hp = ((@current_user.level * 2) + 68)
        else
            if @current_user.hp >= ((@current_user.level * 2) + 68)
                @current_user.hp = ((@current_user.level * 2) + 68)
            end
            flash.now[:notice] = "クリア！経験値+30/HP+10"
        end
        @current_user.save
        if @current_user.machika_token
            @current_user.machika_token = @current_user.machika_token + 1
            @current_user.save
            flash.now[:notice] = flash.now[:notice] + "💌さらにMaChiKaがサブクエスト投稿者からあなたに+1贈呈されました"
            @post = Post.find_by(id: params[:post_id])
            @user = User.where(uid: @post.post_uid).order(created_at: :desc).first
            if @user.machika_token
                @user.machika_token = @user.machika_token - 1
                if @user.machika_token < 0
                    @user.machika_token = 0
                end
                @user.save
            end
        end
    end
    respond_to do |format|
        format.js { @comment }
    end
    # redirect_to post_path(@post)
end

def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    flash[:notice] = "コメントを削除しました！"
    redirect_to post_path(@post)
end

private
    def comment_params
        if params[:comment][:image].present?
            params.require(:comment).permit(:body, :user_uid, :image)
        else
            params.require(:comment).permit(:body, :user_uid)
        end
    end

private
    def notifications
        questbody = params[:comment][:body]
        if questbody.size >= 4
            @post = Post.find_by(id: params[:post_id])
            @user = User.where(uid: @post.post_uid).order(created_at: :desc).first
            unless @post.post_uid == session[:uid]
                @notification = Notification.new(user_id: @user.id, notified_by_id: @current_user.id, post_id: @post.id, notified_type: 'クリア')
                @notification.save
                user_ids = @user.id
                DeviceWebpushJob.perform_later(user_ids)
                # WebpushService.new.webpush_clients('あなたのサブクエストがクリアされました')
            end
        end
    end

end