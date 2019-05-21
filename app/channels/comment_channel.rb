class CommentChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "comment_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    # Post.create! body: data['body'], id: data['id'], title: data['title'], uid: data['post_uid']
  end

end
