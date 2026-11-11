import { Controller } from "@hotwired/stimulus"

// Reveals hidden item targets a few at a time. Items past the first page are
// rendered with the `hidden` attribute; each click on the button un-hides the
// next batch, and the button disappears once everything is showing.
export default class extends Controller {
  static targets = ["item", "button"]
  static values = { perPage: { type: Number, default: 3 } }

  connect() {
    this.toggleButton()
  }

  more() {
    const next = this.hiddenItems.slice(0, this.perPageValue)
    next.forEach((item) => { item.hidden = false })
    this.toggleButton()

    // Keep keyboard users in place: move focus to the first newly shown card's link
    next[0]?.querySelector("a")?.focus({ preventScroll: false })
  }

  toggleButton() {
    if (this.hasButtonTarget) this.buttonTarget.hidden = this.hiddenItems.length === 0
  }

  get hiddenItems() {
    return this.itemTargets.filter((item) => item.hidden)
  }
}
