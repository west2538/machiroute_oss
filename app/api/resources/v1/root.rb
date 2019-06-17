module Resources
  module V1
    class Root < Grape::API

      version 'v1'
      format :json
      content_type :json, 'application/json'

      helpers do
        def authenticate!
          error!('Unauthorized. Invalid or expired token.', 401) unless current_user
        end

        def current_user
          user = User.where(token: params[:token]).first
          if user
            @current_user = User.find(user.id)
          else
            false
          end
        end
      end

      mount Resources::V1::Posts
      mount Resources::V1::Notifications
      mount Resources::V1::Comments

      # swaggerの設定
      if defined? GrapeSwaggerRails
        add_swagger_documentation(
          # markdown: GrapeSwagger::Markdown::RedcarpetAdapter.new(render_options: { highlighter: :rouge }),
          api_version: 'v1',
          base_path: '',
          hide_documentation_path: true,
          hide_format: true,
          info: {
            title: '',
            description: 'Webアプリ「まちかどルート」のREST API一覧。【注】下記パラメータ以外にもアプリにログインして得られる「冒険者のステータス」のアクセストークンをtokenパラメータとして付与してください。'
            # contact_name: 'Contact name',
            # contact_email: 'west2538@gmail.com'
          }
        )
      end

    end
  end
end