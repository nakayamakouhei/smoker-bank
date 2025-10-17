# db/seeds.rb
# Smoker Bank 用：シリーズ単位の銘柄データを登録
# 「紙巻き」「加熱式」に正確分類済み
# テスト用ランダム生成などは除外

cigarettes = [
  # ==== 紙巻きたばこ ====
  { name: "セブンスター シリーズ",          price: 600, manufacturer: "紙巻き", position: 1 },
  { name: "メビウス シリーズ",              price: 580, manufacturer: "紙巻き", position: 2 },
  { name: "メビウス オプション シリーズ",    price: 580, manufacturer: "紙巻き", position: 3 },
  { name: "メビウス イー シリーズ",          price: 500, manufacturer: "紙巻き", position: 4 },
  { name: "ウィンストン シリーズ",          price: 540, manufacturer: "紙巻き", position: 5 },
  { name: "キャスター シリーズ",            price: 540, manufacturer: "紙巻き", position: 6 },
  { name: "キャビン シリーズ",              price: 540, manufacturer: "紙巻き", position: 7 },
  { name: "キャメル シリーズ",              price: 450, manufacturer: "紙巻き", position: 8 },
  { name: "ピース シリーズ",                price: 600, manufacturer: "紙巻き", position: 9 },
  { name: "ロングピース シリーズ",          price: 600, manufacturer: "紙巻き", position: 10 },
  { name: "ホープ シリーズ",                price: 300, manufacturer: "紙巻き", position: 11 },
  { name: "ピアニッシモ シリーズ",          price: 570, manufacturer: "紙巻き", position: 12 },
  { name: "ハイライト シリーズ",            price: 520, manufacturer: "紙巻き", position: 13 },
  { name: "ケント シリーズ",                price: 520, manufacturer: "紙巻き", position: 14 },
  { name: "ラッキーストライク シリーズ",    price: 600, manufacturer: "紙巻き", position: 15 },
  { name: "マールボロ シリーズ",            price: 640, manufacturer: "紙巻き", position: 16 },
  { name: "アメリカンスピリット シリーズ",  price: 580, manufacturer: "紙巻き", position: 17 },
  { name: "エッセ シリーズ",               price: 540, manufacturer: "紙巻き", position: 18 },
  { name: "ダビドフ シリーズ",             price: 600, manufacturer: "紙巻き", position: 19 },
  { name: "ウエスト シリーズ",             price: 520, manufacturer: "紙巻き", position: 20 },
  { name: "ペペ シリーズ",                 price: 550, manufacturer: "紙巻き", position: 21 },

  # ==== 加熱式たばこ ====
  { name: "テリア シリーズ（IQOS用）",             price: 580, manufacturer: "加熱式", position: 22 },
  { name: "センティア シリーズ（IQOS用）",         price: 530, manufacturer: "加熱式", position: 23 },
  { name: "マールボロ ヒートスティック シリーズ", price: 580, manufacturer: "加熱式", position: 24 },
  { name: "ネオ スティック シリーズ（glo用）",    price: 540, manufacturer: "加熱式", position: 25 },
  { name: "クール スティック シリーズ（glo用）",  price: 540, manufacturer: "加熱式", position: 26 },
  { name: "ケント スティック シリーズ（glo用）",  price: 540, manufacturer: "加熱式", position: 27 },
  { name: "プルーム テック シリーズ",             price: 580, manufacturer: "加熱式", position: 28 },
  { name: "プルーム テック プラス シリーズ",       price: 580, manufacturer: "加熱式", position: 29 },
  { name: "プルーム エス シリーズ",               price: 580, manufacturer: "加熱式", position: 30 },
  { name: "プルーム X シリーズ",                 price: 580, manufacturer: "加熱式", position: 31 },
  { name: "リル ハイブリッド シリーズ",           price: 510, manufacturer: "加熱式", position: 32 }
]

cigarettes.each do |c|
  Cigarette.find_or_create_by!(name: c[:name]) do |i|
    i.price        = c[:price]
    i.manufacturer = c[:manufacturer]
    i.position     = c[:position]
  end
end
