class ErrorsController < ActionController::Base
    def not_found
        flash[:notice] = "冒険の世界におかえりなさい！"
        redirect_to root_path
    end
end