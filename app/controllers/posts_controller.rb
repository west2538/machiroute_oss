class PostsController < ApplicationController

    before_action :current_user

    def index
        if session[:uid] && @current_user
            @posts01 = Post.includes(:comments).where.not(title: '冒険の拠点を登録').page(params[:page]).per(20).order(updated_at: :desc)
            @posts02 = Post.includes(:comments).where.not(title: '冒険の拠点を登録').where(post_uid: session[:uid]).page(params[:page]).per(10).order(created_at: :desc)
            like_post_ids = Like.where(user_id: @current_user.id).order(created_at: :desc).pluck(:post_id)
            @posts03 = Post.includes(:comments).where(id: like_post_ids).page(params[:page]).per(3).order_as_specified(id: like_post_ids)

            @online_users = User.where.not(online_at: nil).limit(12).order(online_at: :desc)

            @special_posts = Post.includes(:comments).where.not(scenario_start: nil).where('scenario_start <= ?', Date.today).where('scenario_end >= ?', Date.today)
            array_posts01 = @posts01.to_a
            @special_posts = @special_posts.to_a
            @special_posts.delete_if do |special_post|
                array_posts01.include?(special_post)
            end

            @ranks = Comment.where('created_at > ?', Time.now - 7.days).group(:post_id).order(Arel.sql('count(post_id) desc')).limit(3).pluck(:post_id)
            @boukensha_count = User.count
            @clears_count = Comment.count
            @user_clears_count = Comment.where(user_uid: session[:uid]).count
            @level_average = User.average(:level).round
            @twitter_auth = Auth.find_by(user_id: @current_user.id)
        end

        # これ以下はAjax通信の場合のみ通過
        return unless request.xhr?

        case params[:type]
        when 'posts01', 'posts02', 'posts03'
        render "posts/#{params[:type]}"
        end
    end
    
    def show
        @post = Post.includes([:likes, :comments]).find(params[:id])
        @comment = Comment.where(post_id: params[:id]).order(created_at: :desc)

        @og_title = @post.body.truncate(17)

        if @post.image.attached?
            @imgurl = url_for(@post.image.variant(resize: "738x600", auto_orient: true, strip: true, quality: 60))
            # begin
                # @imgpixel = MiniMagick::Image.open(@imgurl)
            # rescue => e
                @imgpixel = { :width => 640, :height => 427 }
            # end
        end

        # @likes_count = Like.where(post_id: @post.id).count

        if @post.latitude.present?
            @hash1 = Gmaps4rails.build_markers(@post) do |post, marker|
                marker.lat post.latitude
                marker.lng post.longitude

                marker.picture({
                    :url => "https://maps.google.co.jp/mapfiles/ms/icons/red-dot.png",
                    :width   => 32,
                    :height  => 32
                })

                marker.infowindow render_to_string(partial: "infowindow", locals: { post: post })
            end
        end
        @qroute = Qroute.where(post_id: @post.id)
        if @qroute.present?
            i = 0
            @hash2 = Gmaps4rails.build_markers(@qroute) do |qroute, marker|
                marker.lat qroute.latitude
                marker.lng qroute.longitude

                i = i + 1

                marker.picture({
                    :url => "https://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=" + i.to_s + "|008080|ffffff",
                    :width   => 32,
                    :height  => 32
                })

                marker.infowindow render_to_string(partial: "infowindow2", locals: { qroute: qroute })
            end
        end

    end

    def new
        @post = Post.new
    end

    def create

        # if post_params[:image] != nil
        #     uploaded_file = post_params[:image]
        #     output_path = Rails.root.join('public', uploaded_file.original_filename)
        #     img = MiniMagick::Image.read(uploaded_file)
        #     img.resize "738x600"
        #     img.quality "60"
        #     img.write output_path
        #     image_file = File.open(output_path)

        #     require "google/cloud/vision"
        #     image_annotator = Google::Cloud::Vision::ImageAnnotator.new
        #     response = image_annotator.safe_search_detection image: image_file
        #     response.responses.each do |res|
        #     safe_search = res.safe_search_annotation
        #         if safe_search.adult.to_s == "VERY_LIKELY" || safe_search.adult.to_s == "LIKELY"
        #             File.delete(output_path)
        #             flash[:error] = "不適切な画像と判断されました powered by Google Cloud Vision"
        #             redirect_to root_path
        #             return
        #         elsif safe_search.violence.to_s == 'VERY_LIKELY' || safe_search.violence.to_s == 'LIKELY'
        #             File.delete(output_path)
        #             flash[:error] = "不適切な画像と判断されました powered by Google Cloud Vision"
        #             redirect_to root_path
        #             return
        #         elsif safe_search.medical.to_s == 'VERY_LIKELY' || safe_search.medical.to_s == 'LIKELY'
        #             File.delete(output_path)
        #             flash[:error] = "不適切な画像と判断されました powered by Google Cloud Vision"
        #             redirect_to root_path
        #             return
        #         end
        #     end
        # end

        @post = Post.new(post_params)
        @post.post_uid = session[:uid]
        if @post.title == "ニュース"
            begin
                og = OpenGraph.new(@post.newsurl)
                @post.newsimage = og.images[0]
                @post.newstitle = og.title
                if @post.newstitle == @post.newsurl
                    render 'new'
                    return
                end
            rescue => e
            end
            unless @post.newstitle.present?
                @post.newstitle = "タイトルなし"
            end
        end

        if @post.title == "新規サブクエスト"
            @post.placename = params[:placename][0]
        elsif @post.title == "冒険の拠点を登録"
            @post.placename = params[:placename][1]
        end
        if @post.title == "新規サブクエスト" && @post.scenario_start.present?
            sabun = (@post.scenario_start - Date.today).to_i
            unless sabun >= 1
                flash.now[:error] = "開始日は明日以降で！"
                render 'new'
                return
            end
            sabun = (@post.scenario_end - @post.scenario_start).to_i
            unless sabun <= 10
                flash.now[:error] = "期間は最長10日間まで！"
                render 'new'
                return
            end
            unless sabun >= 0
                flash.now[:error] = "終了日は開始日以降で！"
                render 'new'
                return
            end
        end

        if session[:uid] && @current_user

            if @post.save
                unless @post.title == "新規サブクエスト"
                    if @post.title == "駅でチェックイン" || @post.title == "チェックイン"
                        body_status = @post.body + "\n┏┿────────────\n╂┘ at " +  @post.stationname + "\n ─────────────┿┛\n#" + @post.title
                    elsif @post.title == "ニュース"
                        body_status = @post.body + "\n\n#" + @post.title + "\n┏┿────────────\n╂┘ " + @post.newstitle.to_s + "\n ─────────────┿┛\n" + @post.newsurl
                    elsif @post.title == "書籍や漫画を読んだ"
                        if @post.bookcover.present?
                            body_status = @post.body + "\n\n#" + @post.title + "\n┏┿────────────\n╂┘ " + @post.booktitle + "\n" + @post.bookauthor + "\n" + @post.bookpublisher + "\n ─────────────┿┛\n" + @post.bookcover
                        else
                            body_status = @post.body + "\n\n#" + @post.title + "\n┏┿────────────\n╂┘ " + @post.booktitle + "\n" + @post.bookauthor + "\n" + @post.bookpublisher + "\n ─────────────┿┛\n"
                        end
                    elsif @post.title == "冒険の拠点を登録"
                        mapstr = "https://maps.google.com/maps?q=" + @post.latitude.to_s + "," + @post.longitude.to_s + "+" + @post.placename
                        mapuri = URI.encode(mapstr)
                        body_status = "#冒険の拠点が登録されました\n┏┿────────────\n╂┘ " + @post.placename + "\n ─────────────┿┛\n" + @post.body + "\n" + mapuri
                    elsif session[:provider] == 'twitter' && session[:oauth_token] && @post.title == "冒険中のつぶやき"
                        if Auth.find_by(user_id: @current_user.id)
                            body_status = @post.body
                            access_token = session[:oauth_token]
                            access_token_secret = session[:oauth_token_secret] 
                            PostTweetJob.perform_later(body_status,access_token,access_token_secret)
                        end
                    else
                        body_status = @post.body
                    end
                    access_token = session[:token]
                    domain_array = @current_user.uid.split('@')
                    domain = domain_array.last
                    MastodonTootJob.perform_later(domain,access_token,body_status,@post)
                end
            else
                render 'new'
                return
            end
            # if post_params[:image] != nil
            #     File.delete(output_path)
            # end
            if @post.title == "復活の呪文でHP回復"
                @current_user.hp = @current_user.hp + 100
                @current_user.exp = @current_user.exp - 90
                if @current_user.exp <= 0
                    @current_user.exp = 0
                end
                flash[:notice] = "復活！経験値-90/HP+100"
            elsif @post.title == "書籍や漫画を読んだ"
                @current_user.exp = @current_user.exp + 30
                @current_user.hp = @current_user.hp - 10
                if @current_user.hp <= 0
                    @current_user.hp = 0
                end
                flash[:notice] = "投稿完了！経験値+30/HP-10"
            elsif @post.title == "駅でチェックイン"
                @current_user.exp = @current_user.exp + 20
                @current_user.hp = @current_user.hp - 10
                if @current_user.hp <= 0
                    @current_user.hp = 0
                end
                flash[:notice] = "投稿完了！経験値+20/HP-10"
            elsif @post.title == "ニュース"
                @current_user.exp = @current_user.exp + 20
                @current_user.hp = @current_user.hp - 10
                if @current_user.hp <= 0
                    @current_user.hp = 0
                end
                flash[:notice] = "投稿完了！経験値+20/HP-10"
            elsif @post.title == "新規サブクエスト"
                @current_user.exp = @current_user.exp + 30
                @current_user.hp = @current_user.hp - 10
                if @current_user.hp <= 0
                    @current_user.hp = 0
                end
                flash[:notice] = "投稿完了！経験値+30/HP-10"
            else
            @current_user.exp = @current_user.exp + 10
            @current_user.hp = @current_user.hp - 10
            flash[:notice] = "投稿完了！経験値+10/HP-10"
            end
            if @current_user.exp >= (@current_user.level * 100)
                flash[:notice] = "🎉レベルアップしたよ！✨"
                @current_user.level = @current_user.level + 1
                @current_user.hp = ((@current_user.level * 2) + 68)
            end
            if @current_user.hp <= 0
                @current_user.hp = 0
                flash[:error] = "投稿でHPを使い果たして冒険中に倒れました..。投稿画面で「復活の呪文」を唱えよう！"
            end
            @current_user.save

        end
        if @post.title == "冒険の拠点を登録"
            flash.now[:notice] = "冒険の拠点を登録しました！"
            render 'map'
            return
        end
        redirect_to @current_user
        # redirect_to root_path
    end

    def edit
        @post = Post.find(params[:id])
    end

    def update

        # if post_params[:image] != nil
        #     uploaded_file = post_params[:image]
        #     output_path = Rails.root.join('public', uploaded_file.original_filename)
        #     img = MiniMagick::Image.read(uploaded_file)
        #     img.resize "700x700"
        #     img.write output_path
        #     image_file = File.open(output_path)

        #     image_annotator = Google::Cloud::Vision::ImageAnnotator.new
        #     response = image_annotator.safe_search_detection image: image_file
        #     response.responses.each do |res|
        #     safe_search = res.safe_search_annotation
        #         if safe_search.adult.to_s == "VERY_LIKELY" || safe_search.adult.to_s == "LIKELY"
        #             flash[:error] = "不適切な画像と判断されました powered by Google Cloud Vision"
        #             redirect_to root_path
        #             return
        #         elsif safe_search.violence.to_s == 'VERY_LIKELY' || safe_search.violence.to_s == 'LIKELY'
        #             flash[:error] = "不適切な画像と判断されました powered by Google Cloud Vision"
        #             redirect_to root_path
        #             return
        #         elsif safe_search.medical.to_s == 'VERY_LIKELY' || safe_search.medical.to_s == 'LIKELY'
        #             flash[:error] = "不適切な画像と判断されました powered by Google Cloud Vision"
        #             redirect_to root_path
        #             return
        #         end
        #     end
        #     File.delete(output_path)
        # end

        @post = Post.find(params[:id])
        if @post.title == "新規サブクエスト"
            @post.placename = params[:placename][0]
        elsif @post.title == "冒険の拠点を登録"
            @post.placename = params[:placename][1]
        end
        if @post.update(post_params)
            flash[:notice] = "編集しました！"
            redirect_to post_path(@post)
        else
            render 'edit'
        end
    end

    def destroy
        @post = Post.find(params[:id])
        @post.destroy
        flash[:notice] = "削除しました！"
        redirect_to root_path
    end

    def form2
        @post = Post.new
        @post.latitude = params[:latitude]
        @post.longitude = params[:longitude]
    end

    def form3
        @post = Post.new
        @post.label_list = params[:qtag]
    end

    def gallery
        @post = Post.includes(:comments).where(id: ActiveStorage::Attachment.order(Arel.sql('random()')).limit(10).pluck(:record_id))
    end

    def tag
        if params[:tagsearch] != nil
            @qtag = params[:tagsearch]
            @post = Post.includes(:comments).page(params[:page]).per(10).tagged_with(@qtag)
        else
            @qtag = ActsAsTaggableOn::Tag.find(params[:tag])
            @post = Post.includes(:comments).page(params[:page]).per(10).tagged_with(@qtag)
        end
    end

    def unclear
        if session[:uid] && @current_user
            like_post_ids = Like.where(user_id: @current_user.id).order(created_at: :desc).pluck(:post_id)
            @post = Post.includes(:comments).where(id: like_post_ids).order_as_specified(id: like_post_ids)

            # like_post_ids = Like.where(user_id: @current_user.id).order(created_at: :desc).limit(100).pluck(:post_id)
            # @post = Post.includes(:comments).where(id: like_post_ids).page(params[:page]).per(10).order_as_specified(id: like_post_ids)
        end
    end

    def map
        @post = Post.includes(:comments).where.not(latitude: nil).order(created_at: :desc)
    end

    def auto_complete
        posts = ActsAsTaggableOn::Tag.all.select(:name).where("name like '%" + params[:term] + "%'").order(:name)
        posts = posts.map(&:name)
        render json: posts.to_json
    end

    private
    def post_params
        params.require(:post).permit(
        :title, :body, :image, :latitude, :longitude, :label_list, :bookisbn, :booktitle, :bookpublisher, :bookauthor, :bookpubdate, :bookcover, :newsurl, :newstitle, :newsimage, :stationname, :scenario_start, :scenario_end,
        placename:[], qroutes_attributes: [:id, :post_id, :qplacename, :qdescription, :latitude, :longitude, :_destroy]
        )
    end
end
