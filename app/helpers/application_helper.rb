module ApplicationHelper
  def default_meta_tags
    {
      site: 'Smoker Bank',
      title: '喫煙記録アプリ',
      reverse: true,
      charset: 'utf-8',
      description: 'Smoker Bankでは、たばこの購入履歴を記録します。また、合計金額に応じた「もしかえたもの」を検索できます。',
      keywords: 'たばこ,煙草,タバコ,喫煙,禁煙,記録',
      canonical: root_url,
      separator: '|',
      og:{
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: root_url,
        image: image_url('ogp.png'),
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary_large_image',
        image: image_url('ogp.png')
      }
    }
  end
end
