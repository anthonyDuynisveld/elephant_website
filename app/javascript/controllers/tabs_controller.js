import { Controller } from "@hotwired/stimulus"

// Accessible tabs (WAI-ARIA tabs pattern). Each tab target controls the panel whose
// id is in its aria-controls. Arrow keys, Home and End move between tabs, and the
// selected tab is kept in the URL hash so a tab can be linked to directly.
export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    const fromHash = this.tabTargets.find((tab) => `#${this.panelId(tab)}` === window.location.hash)
    if (fromHash) this.activate(fromHash)
  }

  select(event) {
    this.activate(event.currentTarget, { updateHash: true })
  }

  navigate(event) {
    const tabs = this.tabTargets
    const index = tabs.indexOf(event.currentTarget)
    const next = {
      ArrowRight: tabs[(index + 1) % tabs.length],
      ArrowLeft: tabs[(index - 1 + tabs.length) % tabs.length],
      Home: tabs[0],
      End: tabs[tabs.length - 1]
    }[event.key]
    if (!next) return

    event.preventDefault()
    this.activate(next, { updateHash: true })
    next.focus()
  }

  activate(tab, { updateHash = false } = {}) {
    this.tabTargets.forEach((other) => {
      const selected = other === tab
      other.setAttribute("aria-selected", selected)
      other.tabIndex = selected ? 0 : -1
    })
    this.panelTargets.forEach((panel) => { panel.hidden = panel.id !== this.panelId(tab) })

    // replaceState (not location.hash) so the page doesn't jump and Turbo's history entry is kept
    if (updateHash) history.replaceState(history.state, "", `#${this.panelId(tab)}`)
  }

  panelId(tab) {
    return tab.getAttribute("aria-controls")
  }
}
