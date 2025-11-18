import { Controller } from "@hotwired/stimulus"

// Mobile-only smooth scroll for how-to anchor
export default class extends Controller {
  connect() {
    // no-op; action-driven
  }

  scroll(event) {
    const href = event.currentTarget.getAttribute("href")
    if (!href || !href.startsWith("#")) return

    const target = document.querySelector(href)
    if (!target) return

    event.preventDefault()
    target.scrollIntoView({ behavior: "smooth", block: "start" })
  }
}
