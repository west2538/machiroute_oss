@posts = Post.page(params[:page]).per(20).order(created_at: :desc)
# @latest_post = Post.order(updated_at: :desc).first

# cache "rss-last-updated_at_#{@latest_post.updated_at.to_i}", expires_in: 1.hours do

    xml.instruct! :xml, version: 1.0
    xml.rss(version: '2.0') do
    xml.channel do
        xml.title 'まちかどルート'
        xml.description 'リアルRPG！あなたの冒険が世界をちょっと楽しくする。ここはサブクエストをつくってクリアするWebアプリ「まちかどルート」です。Your route changes the world.'
        xml.link 'https://machiroute.herokuapp.com/rss'
        xml.language 'ja'
        xml.lastBuildDate Time.current.rfc822
        xml.generator 'まちかどルートRSS'
        xml.category '新規サブクエスト'
        # xml.images do
        #   xml.url current_user.thumb_url
        #   xml.title current_user.name
        #   xml.link current_user.page_path(full_path: true)
        # end
  
        @posts.each do |post|
        if post.title == '新規サブクエスト'
          xml.item do
            xml.title post.body
            xml.link 'https://machiroute.herokuapp.com/posts/' + post.id.to_s
            # xml.description post.body
            xml.pubDate post.updated_at.rfc822
            # xml.enclosure post.image
          end
        end
        end
    end
    end

# end