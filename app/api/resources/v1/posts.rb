module Resources
  module V1
    class Posts < Grape::API
      resources :posts do

        # /api/v1/posts
        desc '冒険中のつぶやき'
        params do
          requires :body, type: String, desc: '本文'
        end
        post do
          authenticate!
          @post = Post.new(body: params[:body])
          @post.title = '冒険中のつぶやき'
          @post.post_uid = @current_user.uid
          url = ' '
          if @post.save
            status 201
            present @post, with: Entities::V1::PostEntity
            access_token = @current_user.token
            domain_array = @current_user.uid.split('@')
            domain = domain_array.last
            MastodonTootapiJob.perform_later(domain,access_token,url,@post)
          else
            status 400
            present @post.errors
          end
        end

        # /api/v1/posts/news
        desc 'ニュース'
        params do
          requires :body, type: String, desc: '本文'
          requires :url, type: String, desc: 'ニュースURL'
        end
        post :news do
          authenticate!
          @post = Post.new(body: params[:body])
          @post.post_uid = @current_user.uid
          @post.title = 'ニュース'
          url = params[:url]
          @post.newsurl = url
          begin
            og = OpenGraph.new(@post.newsurl)
            @post.newsimage = og.images[0]
            @post.newstitle = og.title
            if @post.newstitle == @post.newsurl
              @post.newstitle = 'タイトルなし'
            end
          rescue => e
          end
          if @post.save
            status 201
            present @post, with: Entities::V1::PostEntity
            access_token = @current_user.token
            domain_array = @current_user.uid.split('@')
            domain = domain_array.last
            MastodonTootapiJob.perform_later(domain,access_token,url,@post)
          else
            status 400
            present @post.errors
          end
        end

        # /api/v1/posts/checkin
        desc 'チェックイン'
        params do
          requires :body, type: String, desc: '本文'
          requires :spotname, type: String, desc: 'チェックインスポット名'
        end
        post :checkin do
          authenticate!
          @post = Post.new(body: params[:body])
          @post.post_uid = @current_user.uid
          @post.title = '駅でチェックイン'
          @post.stationname = params[:spotname]
          if params[:url]
            url = params[:url]
          else
            url = ' '
          end
          if @post.save
            status 201
            present @post, with: Entities::V1::PostEntity
            access_token = @current_user.token
            domain_array = @current_user.uid.split('@')
            domain = domain_array.last
            MastodonTootapiJob.perform_later(domain,access_token,url,@post)
          else
            status 400
            present @post.errors
          end
        end

      end
    end
  end
end