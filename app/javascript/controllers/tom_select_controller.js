import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

export default class extends Controller {
  static targets = ["select", "price"]

  connect() {
    this.tomSelect = new TomSelect(this.selectTarget, {
      placeholder: "銘柄を検索または選択",
      sortField: [],
      create: false,
      allowEmptyOption: true,
      render: {
        no_results: () => {
          return '<div class="px-3 py-2 text-xs text-slate-500">該当する銘柄は見つかりません</div>'
        }
      }
    })

    this.clearButton = document.createElement("button")
    this.clearButton.type = "button"
    this.clearButton.innerHTML = "×"
    this.clearButton.className = "tom-select-clear hidden"
    this.clearButton.addEventListener("click", () => this.handleClear())
    this.tomSelect.wrapper.appendChild(this.clearButton)

    this.updatePrice()
    this.toggleClearButton()

    this.tomSelect.on("change", () => {
      this.updatePrice()
      this.toggleClearButton()
    })
  }

  disconnect() {
    if (this.clearButton) {
      this.clearButton.remove()
      this.clearButton = null
    }

    if (this.tomSelect) {
      this.tomSelect.destroy()
      this.tomSelect = null
    }
  }

  handleClear() {
    if (!this.tomSelect) return

    this.tomSelect.clear(true)
    this.updatePrice()
    this.toggleClearButton()
  }

  updatePrice() {
    if (!this.hasPriceTarget) return

    const selectedOption = this.selectTarget.selectedOptions[0]
    const price = selectedOption?.dataset.price
    this.priceTarget.textContent = price ? `${Number(price).toLocaleString()}円` : "―"
  }

  toggleClearButton() {
    if (!this.clearButton) return
    const hasValue = this.selectTarget.value && this.selectTarget.value.length > 0
    this.clearButton.classList.toggle("hidden", !hasValue)
  }
}
