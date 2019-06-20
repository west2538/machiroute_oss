class CommentBroadcastJob < ApplicationJob
    queue_as :default
  
    def perform(comment)
      bokenshanum = User.count.to_s(:delimited)
      clearnum = Comment.count.to_s(:delimited)
      levelavrg = User.average(:level).round
  
      ActionCable.server.broadcast 'comment_channel', {bokenshanum: bokenshanum, clearnum: clearnum, levelavrg:levelavrg}
    end
  end
  