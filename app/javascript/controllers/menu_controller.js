import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    // メニュー外クリック用リスナーを追加
    this.outsideClickListener = this.handleOutsideClick.bind(this)
    document.addEventListener("click", this.outsideClickListener)

    // Turboのスナップショット保存前にメニューを閉じる
    this.beforeCacheListener = this.handleBeforeCache.bind(this)
    document.addEventListener("turbo:before-cache", this.beforeCacheListener)
  }

  disconnect() {
    // コントローラー破棄時にクリーンアップ
    document.removeEventListener("click", this.outsideClickListener)
    document.removeEventListener("turbo:before-cache", this.beforeCacheListener)
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

  handleBeforeCache() {
    // キャッシュ保存時には必ず非表示にする
    this.menuTarget.classList.add("hidden")
  }
}
