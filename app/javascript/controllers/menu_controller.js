// app/javascript/controllers/menu_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    // メニュー外クリック用リスナーを追加
    this.outsideClickListener = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.outsideClickListener)
  }

  disconnect() {
    // コントローラー破棄時にクリーンアップ
    document.removeEventListener("click", this.outsideClickListener)
  }

  toggle(event) {
    event.stopPropagation() // ボタン自身のクリックは無視
    this.menuTarget.classList.toggle("hidden")
  }

  handleOutsideClick(event) {
    // メニューが開いていて、かつクリックがメニュー外なら閉じる
    if (
      !this.menuTarget.classList.contains("hidden") &&
      !this.menuTarget.contains(event.target) &&
      !event.target.closest("[data-action~='click->menu#toggle']")
    ) {
      this.menuTarget.classList.add("hidden")
    }
  }
}
