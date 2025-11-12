import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["overlay", "content"];

    open() {
        this.overlayTarget.classList.remove("hidden");
    }

    close() {
        this.overlayTarget.classList.add("hidden");
    }

    save() {
        const time = document.getElementById("notification_time").value;
        if (time) {
            alert(`通知時刻を ${time} に設定しました！`);
            this.close();
            // 後でここにAPIリクエストを追加してDBに保存する
        } else {
            alert("時間を選択してください");
        }
    }
}
