class DeleteChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "delete_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def delete(data)
    ActionCable.server.broadcast 'delete_channel', id: data['id']
    post = Post.find_by(id: data['id'])
    post.destroy
  end
end
