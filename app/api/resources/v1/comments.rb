module Resources
  module V1
    class Comments < Grape::API
      resources :comments do

        # /api/v1/comments
        desc 'アクティビティ・チャートJSON出力'
        params do
          requires :user_id, type: Integer, desc: 'ユーザーID'
        end
        get do
          user = User.find(params[:user_id])
          from = params[:start]
          to = params[:stop]
  
          comments1 = Post.where(post_uid: user.uid, created_at: from..to)
          comments2 = Comment.where(user_uid: user.uid, created_at: from..to)
          comments1 = comments1.to_a
          comments2 = comments2.to_a
          comments = comments1 + comments2
          comments.map{|c| c.created_at.to_i}.inject(Hash.new(0)){|h, tm| h[tm] += 1; h}.to_json
        end

      end
    end
  end
end