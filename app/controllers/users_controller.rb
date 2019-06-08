class UsersController < ApplicationController

    before_action :current_user

    def show
        @user = User.find(params[:id])
        @user_clears_count = Comment.where(user_uid: @user.uid).count
        @user_posts_count = Post.where(post_uid: @user.uid).count
        if @current_user.present?
            if @user.uid == @current_user.uid && session[:provider] == 'twitter' && session[:oauth_token] && @auth_user
                unless @current_user.twitter_screenname.present?
                    client = Twitter::REST::Client.new do |config|
                        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
                        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
                        config.access_token        = session[:oauth_token]
                        config.access_token_secret = session[:oauth_token_secret] 
                    end
                    @current_user.twitter_screenname = client.user.screen_name
                    @current_user.save
                end
            end
        end
    end

    def edit
        @user = User.find(params[:id])
        @user_clears_count = Comment.where(user_uid: @current_user.uid).count
        @user.note = ApplicationController.helpers.strip_tags(@user.note)
        @user.fields1_value = ApplicationController.helpers.strip_tags(@user.fields1_value)
        @user.fields2_value = ApplicationController.helpers.strip_tags(@user.fields2_value)
        @user.fields3_value = ApplicationController.helpers.strip_tags(@user.fields3_value)
        @user.fields4_value = ApplicationController.helpers.strip_tags(@user.fields4_value)
    end

    def update
        @user = User.find(params[:id])
        @user_clears_count = Comment.where(user_uid: @user.uid).count

        if @current_user.uid == 'townsguild@another-guild.com'
            access_token = @user.token
        else
            access_token = session[:token]
        end
        domain_array = @user.uid.split('@')
        domain = domain_array.last

        if user_params[:image] != nil
            uploaded_file = user_params[:image]
            output_path = Rails.root.join('public', uploaded_file.original_filename)
            img = MiniMagick::Image.read(uploaded_file)
            img.resize "300x300"
            img.quality "60"
            img.write output_path
            image_file = File.open(output_path)

            # image_annotator = Google::Cloud::Vision::ImageAnnotator.new
            # response = image_annotator.safe_search_detection image: image_file
            # response.responses.each do |res|
            # safe_search = res.safe_search_annotation
            #     if safe_search.adult.to_s == "VERY_LIKELY" || safe_search.adult.to_s == "LIKELY"
            #         File.delete(output_path)
            #         flash[:error] = "不適切な画像と判断されました powered by Google Cloud Vision"
            #         redirect_to root_path
            #         return
            #     elsif safe_search.violence.to_s == 'VERY_LIKELY' || safe_search.violence.to_s == 'LIKELY'
            #         File.delete(output_path)
            #         flash[:error] = "不適切な画像と判断されました powered by Google Cloud Vision"
            #         redirect_to root_path
            #         return
            #     elsif safe_search.medical.to_s == 'VERY_LIKELY' || safe_search.medical.to_s == 'LIKELY'
            #         File.delete(output_path)
            #         flash[:error] = "不適切な画像と判断されました powered by Google Cloud Vision"
            #         redirect_to root_path
            #         return
            #     end
            # end

            user_array = 
            {
                "display_name": user_params[:display_name],
                "note": user_params[:note],
                "avatar": output_path
            }
            client = Mastodon::REST::Client.new(base_url: "https://#{domain}", bearer_token: access_token)
            result = client.update_credentials(user_array)
            @user.avatar = result.avatar
            @user.save
            File.delete(output_path)
        else
            user_array = 
            {
                "display_name": user_params[:display_name],
                "note": user_params[:note]
                # "fields_attributes": 
                # [
                #     {
                #         "name": @user.fields1_name,
                #         "value": @user.fields1_value
                #     },
                #     {
                #         "name": @user.fields2_name,
                #         "value": @user.fields2_value
                #     },
                #     {
                #         "name": @user.fields3_name,
                #         "value": @user.fields3_value
                #     },
                #     {
                #         "name": @user.fields4_name,
                #         "value": @user.fields4_value
                #     } 
                # ]
            }
            client = Mastodon::REST::Client.new(base_url: "https://#{domain}", bearer_token: access_token)
            client.update_credentials(user_array)
        end

        if @user.update(user_params)
            flash[:notice] = "ステータスを更新しました" 
            redirect_to @user
        else
            render 'edit'
        end
    end

    private
    def user_params
        params.require(:user).permit(
            :display_name, :note, :image, :fields1_name, :fields2_name, :fields3_name, :fields4_name, :fields1_value, :fields2_value, :fields3_value, :fields4_value, :shogo
            )
    end

end