self.addEventListener("install", (event) => {
    console.log("Service Worker: installed");
    // キャッシュの初期化などをここでやる（今回は省略）
});

self.addEventListener("activate", (event) => {
    console.log("Service Worker: activated");
    // 古いキャッシュの削除などをここでやる（今回は省略）
});

self.addEventListener("fetch", (event) => {
    // リクエストをそのままネットワークへ流す
    // 後でキャッシュ戦略を追加できる
    event.respondWith(fetch(event.request));
});
  