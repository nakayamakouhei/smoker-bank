import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loading"
// 全ページ共通ローディングコントローラー
export default class extends Controller {
  static targets = ["overlay"]

  connect() {
    // ページ遷移開始
    document.addEventListener("turbo:visit", () => this.showWithDelay())
    // ページ読み込み完了
    document.addEventListener("turbo:load", () => this.hide())
    // フォーム送信開始
    document.addEventListener("turbo:submit-start", () => this.showWithDelay())
    // フォーム送信完了
    document.addEventListener("turbo:submit-end", () => this.hide())
  }

  // 0.3秒後にスピナー表示
  showWithDelay() {
    this.timer = setTimeout(() => {
      this.overlayTarget.classList.remove("hidden")
      this.overlayTarget.classList.add("opacity-100")
    }, 300)
  }

  hide() {
    clearTimeout(this.timer)
    this.overlayTarget.classList.add("hidden")
    this.overlayTarget.classList.remove("opacity-100")
  }
}
