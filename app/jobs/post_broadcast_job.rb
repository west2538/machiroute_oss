class PostBroadcastJob < ApplicationJob
  queue_as :default

  def perform(post)

    @user = User.where(uid: post.post_uid).order(created_at: :desc).first

    cableuser = post.post_uid.split("@")
    if @user.display_name.present?
      display_name = @user.display_name
    else
      display_name = '@' + cableuser[0]
    end
    unless post.bookcover.present?
      post.bookcover = '/assets/nobookcover.jpg'
    end
    unless post.newsimage.present?
      post.newsimage = '/assets/ogpimage.png'
    end
    cablebokensha = '/users/' + @user.id.to_s
    cabledomain = cableuser[1]
    cabledate1 = post.updated_at.strftime('%-m月%-d日 %-H:%M')
    cabledate2 = post.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    if post.title == 'ニュース'
      if post.newstitle.present?
        newstitle = post.newstitle.truncate(46)
      else
        newstitle = 'タイトルなし'
      end
    end
    URI.extract(post.body).uniq.each {|url| post.body.gsub!(url, '')}
    
    ActionCable.server.broadcast 'post_channel', {body: post.body, id: post.id, title: post.title, uid: post.post_uid, avatar: @user.avatar, level: @user.level, cableuser: cableuser, cabledomain: cabledomain, cablebokensha: cablebokensha, display_name: display_name, cabledate1: cabledate1, cabledate2: cabledate2, booktitle:post.booktitle, bookpublisher:post.bookpublisher, bookauthor:post.bookauthor, bookcover:post.bookcover, newsurl:post.newsurl, newsimage:post.newsimage, newstitle:newstitle, stationname:post.stationname, mstdn_status:post.mstdn_status}

  end

end