import { Controller } from "@hotwired/stimulus"

// Replaces the mouse cursor with an elephant. While a mouse button is held the
// elephant swings its trunk up and sprays water; releasing lowers it again.
//
// Only active for fine pointers that can hover (mouse/trackpad). Touch devices
// and no-JS visitors keep the normal cursor.

const ACTIVE_CLASS = "elephant-cursor-active"
const MIN_SPRAY_MS = 450        // trunk stays up at least this long, even on a quick click
const SPRAY_INTERVAL_MS = 45
const DROPS_PER_BURST = 3

// Where the raised trunk tip sits inside the 48px icon (SVG viewBox 64 -> 48px)
const TRUNK_TIP = { x: 10.5, y: 8 }
// Hotspot = resting trunk tip, so clicks land where the trunk points
const HOTSPOT = { x: 6, y: 37.5 }

// Remember the last position so the cursor doesn't flash at 0,0 after a Turbo visit
let lastPosition = null

export default class extends Controller {
  static targets = ["cursor"]

  connect() {
    this.fineHover = window.matchMedia("(hover: hover) and (pointer: fine)")
    this.reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)")
    if (!this.fineHover.matches) return

    this.enabled = true
    this.sprayTimer = null
    this.sprayStartedAt = 0

    document.documentElement.classList.add(ACTIVE_CLASS)

    this.onMove = this.onMove.bind(this)
    this.onDown = this.onDown.bind(this)
    this.onUp = this.onUp.bind(this)
    this.onLeave = () => this.cursorTarget.classList.remove("is-visible")

    document.addEventListener("pointermove", this.onMove)
    document.addEventListener("pointerdown", this.onDown)
    document.addEventListener("pointerup", this.onUp)
    document.addEventListener("pointercancel", this.onUp)
    document.documentElement.addEventListener("pointerleave", this.onLeave)

    if (lastPosition) this.place(lastPosition.x, lastPosition.y)
  }

  disconnect() {
    if (!this.enabled) return
    this.enabled = false

    document.documentElement.classList.remove(ACTIVE_CLASS)
    document.removeEventListener("pointermove", this.onMove)
    document.removeEventListener("pointerdown", this.onDown)
    document.removeEventListener("pointerup", this.onUp)
    document.removeEventListener("pointercancel", this.onUp)
    document.documentElement.removeEventListener("pointerleave", this.onLeave)
    this.stopSpray(true)
  }

  onMove(event) {
    if (event.pointerType === "touch") return
    lastPosition = { x: event.clientX, y: event.clientY }
    this.place(event.clientX, event.clientY)

    const overLink = event.target.closest?.("a[href], button, summary, [role='button']")
    this.cursorTarget.classList.toggle("is-over-link", Boolean(overLink))
  }

  place(x, y) {
    const el = this.cursorTarget
    el.style.transform = `translate3d(${x - HOTSPOT.x}px, ${y - HOTSPOT.y}px, 0)`
    el.classList.add("is-visible")
  }

  onDown(event) {
    if (event.pointerType === "touch") return
    this.startSpray()
  }

  onUp() {
    this.stopSpray()
  }

  startSpray() {
    if (this.sprayTimer) return
    this.sprayStartedAt = performance.now()
    this.cursorTarget.classList.add("is-spraying")
    if (this.reducedMotion.matches) return

    this.burst()
    this.sprayTimer = setInterval(() => this.burst(), SPRAY_INTERVAL_MS)
  }

  stopSpray(immediate = false) {
    const lower = () => {
      clearInterval(this.sprayTimer)
      this.sprayTimer = null
      this.cursorTarget.classList.remove("is-spraying")
    }

    const remaining = MIN_SPRAY_MS - (performance.now() - this.sprayStartedAt)
    if (immediate || remaining <= 0) return lower()
    setTimeout(lower, remaining)
  }

  // Emit a few water droplets from the raised trunk tip, arcing up and falling back down
  burst() {
    const rect = this.cursorTarget.getBoundingClientRect()
    const originX = rect.left + TRUNK_TIP.x
    const originY = rect.top + TRUNK_TIP.y

    for (let i = 0; i < DROPS_PER_BURST; i++) {
      const drop = document.createElement("span")
      drop.className = "elephant-cursor__drop"
      drop.style.left = `${originX}px`
      drop.style.top = `${originY}px`
      document.body.appendChild(drop)

      const drift = (Math.random() - 0.5) * 70
      const height = 40 + Math.random() * 45
      const fall = 25 + Math.random() * 25

      const animation = drop.animate(
        [
          { transform: "translate(0, 0) scale(1)", opacity: 1 },
          { transform: `translate(${drift * 0.5}px, ${-height}px) scale(1)`, opacity: 1, offset: 0.4 },
          { transform: `translate(${drift}px, ${fall}px) scale(0.5)`, opacity: 0 }
        ],
        { duration: 650 + Math.random() * 250, easing: "cubic-bezier(0.3, 0.6, 0.6, 1)" }
      )
      animation.onfinish = () => drop.remove()
    }
  }
}
