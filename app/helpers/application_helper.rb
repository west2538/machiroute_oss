module ApplicationHelper

  def default_meta_tags
      {
        site: 'リアルRPGのサブクエスト作成アプリ',
        title: 'まちかどルート',
        reverse: true,
        charset: 'utf-8',
        description: 'リアルRPG！あなたの冒険が世界をちょっと楽しくする。サブクエストをつくってクリアするWebアプリ',
        keywords: 'まちかどギルド',
        canonical: request.original_url,
        separator: '|',
        icon: [
          { href: image_url('https://machiroute.herokuapp.com/images/favicon.ico') },
          { href: image_url('https://machiroute.herokuapp.com/images/apple-touch-icon180.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/png' },
        ],
        og: {
          site_name: 'まちかどルート',
          title: 'まちかどルート | リアルRPGのサブクエスト作成アプリ',
          description: 'リアルRPG！あなたの冒険が世界をちょっと楽しくする。サブクエストをつくってクリアするWebアプリ',
          type: 'website',
          url: request.original_url,
          image: image_url('https://machiroute.herokuapp.com/images/ogpimage.png'),
          locale: 'ja_JP',
        },
        twitter: {
          card: 'summary_large_image',
          site: '@townsguild',
          title: 'まちかどルート',
          description: 'リアルRPG！あなたの冒険が世界をちょっと楽しくする。サブクエストをつくってクリアするWebアプリ',
          image: image_url('https://machiroute.herokuapp.com/images/ogpimage.png'),
        }
      }
    end

end
