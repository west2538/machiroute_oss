class PostsController < ApplicationController

    before_action :current_user

    include AjaxHelper

    def index
        if @current_user
            @posts01 = Post.includes(:comments).where.not(title: '冒険の拠点を登録').page(params[:page]).per(20).order(updated_at: :desc)
            @posts02 = Post.includes(:comments).where.not(title: '冒険の拠点を登録').where(post_uid: @current_user.uid).page(params[:page]).per(10).order(created_at: :desc)
            like_post_ids = Like.where(user_id: @current_user.id).order(created_at: :desc).pluck(:post_id)
            @posts03 = Post.includes(:comments).where(id: like_post_ids).page(params[:page]).per(3).order_as_specified(id: like_post_ids)

            @online_users = User.where.not(online_at: nil).limit(12).order(online_at: :desc)

            @special_posts = Post.includes(:comments).where.not(scenario_start: nil).where('scenario_start <= ?', Date.today).where('scenario_end >= ?', Date.today).to_a
            if @special_posts.present?
                array_posts01 = @posts01.to_a
                @special_posts = @special_posts.to_a
                @special_posts.delete_if do |special_post|
                    array_posts01.include?(special_post)
                end
            end

            @ranks = Comment.where('created_at > ?', Time.now - 7.days).group(:post_id).order(Arel.sql('count(post_id) desc')).limit(3).pluck(:post_id).to_a
            @boukensha_count = User.count
            @clears_count = Comment.count
            @user_clears_count = Comment.where(user_uid: @current_user.uid).count
            @level_average = User.average(:level).round
        end

        # これ以下はAjax通信の場合のみ通過
        return unless request.xhr?

        case params[:type]
        when 'posts01', 'posts02', 'posts03'
        render "posts/#{params[:type]}"
        end
    end
    
    def show
        @post = Post.includes([:likes, :comments, :qroutes]).find(params[:id])
        @comment = @post.comments.reorder(created_at: :desc)

        @og_title = @post.body.truncate(17)

        if @post.image.attached?
            @imgurl = url_for(@post.image.variant(resize: "738x600", auto_orient: true, strip: true, quality: 60))
            @imgpixel = { :width => 640, :height => 427 }
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
        @qroute = @post.qroutes.where(post_id: @post.id)
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
        @post = Post.new(post_params)
        @post.post_uid = @current_user.uid
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
                @post.errors.messages[:scenario_start][0] = "開始日は明日以降で！"
                respond_to do |format|
                    format.html { render action: "new" }
                    format.js { @post.errors }
                end
                return
            end
            sabun = (@post.scenario_end - @post.scenario_start).to_i
            unless sabun <= 10
                @post.errors.messages[:scenario_start][0] = "期間は最長10日間まで！"
                respond_to do |format|
                    format.html { render action: "new" }
                    format.js { @post.errors }
                end
                return
            end
            unless sabun >= 0
                @post.errors.messages[:scenario_start][0] = "終了日は開始日以降で！"
                respond_to do |format|
                    format.html { render action: "new" }
                    format.js { @post.errors }
                end
                return
            end
        end

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

            if @post.title == "復活の呪文でHP回復"
                @current_user.hp += 100
                @current_user.exp -= 90
                if @current_user.exp <= 0
                    @current_user.exp = 0
                end
                flash[:notice] = "復活！経験値-90/HP+100"
            elsif @post.title == "書籍や漫画を読んだ"
                @current_user.exp += 30
                @current_user.hp -= 10
                if @current_user.hp <= 0
                    @current_user.hp = 0
                end
                flash[:notice] = "投稿完了！経験値+30/HP-10"
            elsif @post.title == "駅でチェックイン"
                @current_user.exp += 20
                @current_user.hp -= 10
                if @current_user.hp <= 0
                    @current_user.hp = 0
                end
                flash[:notice] = "投稿完了！経験値+20/HP-10"
            elsif @post.title == "ニュース"
                @current_user.exp += 20
                @current_user.hp -= 10
                if @current_user.hp <= 0
                    @current_user.hp = 0
                end
                flash[:notice] = "投稿完了！経験値+20/HP-10"
            elsif @post.title == "新規サブクエスト"
                @current_user.exp += 30
                @current_user.hp -= 10
                if @current_user.hp <= 0
                    @current_user.hp = 0
                end
                flash[:notice] = "投稿完了！経験値+30/HP-10"
            else
            @current_user.exp += 10
            @current_user.hp -= 10
            flash[:notice] = "投稿完了！経験値+10/HP-10"
            end

            if @current_user.exp >= (@current_user.level * 100)
                flash[:notice] = "🎉レベルアップしたよ！✨"
                @current_user.level += 1
                @current_user.hp = ((@current_user.level * 2) + 68)
            end
            if @current_user.hp <= 0
                @current_user.hp = 0
                flash[:error] = "投稿でHPを使い果たして冒険中に倒れました..。投稿画面で「復活の呪文」を唱えよう！"
            end
            @current_user.save
            if @post.title == "冒険の拠点を登録"
                flash[:notice] = "冒険の拠点を登録しました！"
                redirect_to map_path
                return
            end
            respond_to do |format|
                format.js { render ajax_redirect_to(user_path(@current_user)) }
            end
            # redirect_to @current_user
        else
            respond_to do |format|
                format.html { render action: "new" }
                format.js { @post.errors }
            end
        end
    end

    def edit
        @post = Post.find(params[:id])
    end

    def update
        @post = Post.find(params[:id])
        if @post.title == "新規サブクエスト"
            @post.placename = params[:placename][0]
        elsif @post.title == "冒険の拠点を登録"
            @post.placename = params[:placename][0]
        end
        if @post.update(post_params)
            flash[:notice] = "編集しました！"
            if @post.title == "冒険の拠点を登録"
                redirect_to map_path
            else
                redirect_to @post
            end
        else
            respond_to do |format|
                format.html { render action: "edit" }
                format.js { @post.errors }
            end
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
        @og_title = @qtag.to_s.truncate(17)
    end

    def unclear
        if @current_user
            like_post_ids = Like.where(user_id: @current_user.id).order(created_at: :desc).pluck(:post_id)
            @post = Post.includes(:comments).where(id: like_post_ids).order_as_specified(id: like_post_ids)
        end
    end

    def map
        @post = cache_maps
    end

    def auto_complete
        posts = ActsAsTaggableOn::Tag.all.select(:name).where("name like '%" + params[:term] + "%'").order(:name)
        posts = posts.map(&:name)
        render json: posts.to_json
    end

    def battery
        if params[:battery] != nil
            battery = params[:battery]
            @current_user.hp += battery.to_i
            if @current_user.hp >= ((@current_user.level * 2) + 68)
                @current_user.hp = ((@current_user.level * 2) + 68)
            end
            @current_user.save
            flash[:notice] = "HPが回復しました！"
            redirect_to root_path
        else
            flash[:error] = "呪文が失敗しました！"
            redirect_to root_path
        end
    end

    private

    def post_params
        params.require(:post).permit(
        :title, :body, :image, :latitude, :longitude, :label_list, :bookisbn, :booktitle, :bookpublisher, :bookauthor, :bookpubdate, :bookcover, :newsurl, :newstitle, :newsimage, :stationname, :scenario_start, :scenario_end,
        placename:[], qroutes_attributes: [:id, :post_id, :qplacename, :qdescription, :latitude, :longitude, :_destroy]
        )
    end

    def cache_maps
        Rails.cache.fetch("cache_maps", expires_in: 1.hour) do
            Post.includes(:comments).where.not(latitude: nil).order(created_at: :desc).to_a
        end
    end

    # def cache_specialposts
    #     Rails.cache.fetch("cache_specialposts", expires_in: 1.hour) do
    #         Post.includes(:comments).where.not(scenario_start: nil).where('scenario_start <= ?', Date.today).where('scenario_end >= ?', Date.today).to_a
    #     end
    # end

    # def cache_ranks
    #     Rails.cache.fetch("cache_ranks", expires_in: 1.hour) do
    #         Comment.where('created_at > ?', Time.now - 7.days).group(:post_id).order(Arel.sql('count(post_id) desc')).limit(3).pluck(:post_id).to_a
    #     end
    # end

end
