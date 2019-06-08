class LikesController < ApplicationController

    before_action :current_user
    # after_action :notifications, only: [:create]

    def create
        @like = Like.create(user_id: @current_user.id, post_id: params[:post_id])
        @post = Post.find(params[:post_id])
        @current_user.hp += 10
        if @current_user.hp >= ((@current_user.level * 2) + 68)
            @current_user.hp = ((@current_user.level * 2) + 68)
        end
        @current_user.machika_token -= 1
        if @current_user.machika_token < 0
            @current_user.machika_token = 0
            flash.now[:notice] = "せーぶ完了！HP+10💌あなたのMaChiKaが0なので支援できません"
        else
            flash.now[:notice] = "せーぶ完了！HP+10💌MaChiKaをサブクエスト投稿者に+1支援"
            @user = User.where(uid: @post.post_uid).order(created_at: :desc).first
            @user.machika_token += 1
            @user.save
            @current_user.save
        end
        # redirect_to("/posts/#{params[:post_id]}")
    end

    def destroy
        @like = Like.find_by(user_id: @current_user.id, post_id: params[:post_id])
        @like.destroy
        @post = Post.find(params[:post_id])
        @current_user.hp -= 10
        if @current_user.hp < 0
            @current_user.hp = 0
        end
        @current_user.machika_token += 1
        flash.now[:notice] = "せーぶ解除！HP-10💌MaChiKaがあなたに+1戻りました"
        @user = User.where(uid: @post.post_uid).order(created_at: :desc).first
        @user.machika_token -= 1
        if @user.machika_token < 0
            @user.machika_token = 0
        end
        @current_user.save
        @user.save
        # redirect_to("/posts/#{params[:post_id]}")
    end

    # private
    # def notifications
    #     @post = Post.find_by(id: params[:post_id])
    #     @user = User.where(uid: @post.post_uid).order(created_at: :desc).first
    #     unless @post.post_uid == session[:uid]
    #         @notification = Notification.new(user_id: @user.id, notified_by_id: @current_user.id, post_id: @post.id, notified_type: 'せーぶ')
    #         @notification.save
    #     end
    # end

end