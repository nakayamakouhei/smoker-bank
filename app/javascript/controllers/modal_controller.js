import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["overlay", "content"];
    static values = {
        updateUrl: String
    }

    open() {
        this.overlayTarget.classList.remove("hidden");
    }

    close() {
        this.overlayTarget.classList.add("hidden");
    }

    async save() {
        if (!this.canUsePush()) {
            alert("このブラウザでは、プッシュ通知を利用できません。詳しくは右上のメニューにある使い方を参照してください。");
            return;
        }

        const time = document.getElementById("notification_time").value;
        if (!time) {
            alert("時間を選択してください");
            return;
        }

        try {
            // ✅ 通知許可をユーザーに確認
            const permission = await Notification.requestPermission();
            if (permission !== "granted") {
                alert("通知がブロックされています。設定から有効にしてください。");
                return;
            }

            // ✅ Service Worker準備待ち
            const registration = await navigator.serviceWorker.ready;

            // ✅ サーバーからVAPID公開鍵を取得
            const response = await fetch("/push_subscriptions/public_key");
            const { publicKey } = await response.json();

            // ✅ 通知購読を実行
            const subscription = await registration.pushManager.subscribe({
                userVisibleOnly: true,
                applicationServerKey: this.urlBase64ToUint8Array(publicKey),
            });

            // ✅ サーバーへ購読情報＋通知時刻を送信
            const updateUrl = this.hasUpdateUrlValue ? this.updateUrlValue : "/user/update_notification_time";

            await fetch(updateUrl, {
                method: "PATCH",
                headers: {
                    "Content-Type": "application/json",
                    "X-CSRF-Token": document.querySelector('meta[name=\"csrf-token\"]').content
                },
                body: JSON.stringify({
                    notification_time: time,
                    subscription: subscription
                }),
            });

            alert(`通知を ${time} に設定しました。`);
            this.close();
        } catch (error) {
            console.error("通知設定エラー:", error);
            alert("通知の設定に失敗しました。");
        }
    }

    // helper
    urlBase64ToUint8Array(base64String) {
        const padding = "=".repeat((4 - (base64String.length % 4)) % 4);
        const base64 = (base64String + padding).replace(/-/g, "+").replace(/_/g, "/");
        const rawData = atob(base64);
        return Uint8Array.from([...rawData].map((c) => c.charCodeAt(0)));
    }

    canUsePush() {
        return (
            "Notification" in window &&
            "serviceWorker" in navigator &&
            "PushManager" in window
        );
    }
}
