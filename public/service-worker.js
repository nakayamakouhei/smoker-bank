// pwa用設定
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

// webpush通知設定
self.addEventListener("push", function (event) {
    console.log("Push event received:", event);

    const data = event.data.json();

    event.waitUntil(
        self.registration.showNotification(data.title, {
            body: data.body,
            icon: "/icon.png",
        })
    );
});
