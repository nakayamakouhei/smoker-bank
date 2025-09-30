cigarettes = [
  { name: "メビウス ライト",     price: 580, manufacturer: "メビウス",    position: 1 },
  { name: "メビウス メンソール", price: 590, manufacturer: "メビウス",    position: 2 },
  { name: "マルボロ レッド",     price: 640, manufacturer: "マルボロ",    position: 1 },
  { name: "マルボロ ゴールド",   price: 650, manufacturer: "マルボロ",    position: 2 },
  { name: "セブンスター",         price: 600, manufacturer: "セブンスター", position: 1 }
]

cigarettes.each do |c|
  Cigarette.find_or_create_by!(name: c[:name]) do |i|
    i.price        = c[:price]
    i.manufacturer = c[:manufacturer]
    i.position     = c[:position]
  end
end

users = User.all
cigarettes = Cigarette.all

10.times do
  Smoke.create!(
    user: users.sample,                # ランダムユーザー
    cigarette: cigarettes.sample,      # ランダム銘柄
    packs: rand(1..3),                 # 1〜3パック
    bought_date: rand(0..7).days.ago   # 今日〜7日前まで
  )
end

users = User.limit(2)  # 最初の2人を取得

custom_cigarettes = [
  { name: "マイシガーA", price: 700, user_id: users[0].id },
  { name: "マイシガーB", price: 750, user_id: users[0].id },
  { name: "オリジナルC", price: 720, user_id: users[1].id },
  { name: "オリジナルD", price: 760, user_id: users[1].id }
]

custom_cigarettes.each do |c|
  CustomCigarette.find_or_create_by!(name: c[:name], user_id: c[:user_id]) do |i|
    i.price = c[:price]
  end
end

custom_cigarettes = CustomCigarette.all

# 10件のランダム購入ログを作成
10.times do
  c = custom_cigarettes.sample
  CustomCigaretteLog.create!(
    user_id: c.user_id,                  # CustomCigarette の持ち主
    custom_cigarette_id: c.id,
    packs: rand(1..3),                   # 1〜3パック
    bought_date: rand(0..7).days.ago     # 今日から7日前まで
  )
end
