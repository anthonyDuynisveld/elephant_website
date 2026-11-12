import { Controller } from "@hotwired/stimulus"

// Ellie, a mascot elephant who rides along the right edge of the screen. Hovering
// (or keyboard-focusing) any element with a data-mascot-fact attribute makes her
// glide level with it and pop up that fact in a speech bubble. She wobbles while
// the page scrolls and rests in the bottom corner when idle. An optional
// data-mascot-label on the element replaces the default bubble heading.
//
// Only active for devices that can hover; touch devices never see the mascot or
// the 💡 markers on fact blocks.

const ACTIVE_CLASS = "mascot-active"
const TARGET_CLASS = "is-mascot-target"
const HIDE_DELAY_MS = 350      // grace period so moving between blocks doesn't flicker the bubble
const WALK_SETTLE_MS = 250     // stop wobbling this long after the last scroll event
const EDGE_GAP = 16
const MIN_MOVE_PX = 2          // ignore tiny position changes so the glide isn't restarted for nothing
const INTRO_KEY = "mascot-intro-seen"
const INTRO_MS = 6000
const FACT_LABEL = "Ellie's bonus fact"

export default class extends Controller {
  static targets = ["mascot", "bubble", "label", "text"]

  connect() {
    if (!window.matchMedia("(hover: hover) and (pointer: fine)").matches) return

    this.enabled = true
    this.current = null
    // Below this width there's no gutter beside the content, so Ellie stays in the corner
    this.wide = window.matchMedia("(min-width: 1280px)")

    document.documentElement.classList.add(ACTIVE_CLASS)

    this.onOver = this.onOver.bind(this)
    this.onOut = this.onOut.bind(this)
    this.onScroll = this.onScroll.bind(this)
    this.onResize = () => this.position()

    document.addEventListener("pointerover", this.onOver)
    document.addEventListener("pointerout", this.onOut)
    document.addEventListener("focusin", this.onOver)
    document.addEventListener("focusout", this.onOut)
    window.addEventListener("scroll", this.onScroll, { passive: true })
    window.addEventListener("resize", this.onResize)

    // Place her before turning on the glide transition, so she doesn't fly in from the top on every page
    this.rest()
    requestAnimationFrame(() => this.mascotTarget.classList.add("is-ready"))

    this.introduce()
  }

  disconnect() {
    if (!this.enabled) return
    this.enabled = false

    document.documentElement.classList.remove(ACTIVE_CLASS)
    document.removeEventListener("pointerover", this.onOver)
    document.removeEventListener("pointerout", this.onOut)
    document.removeEventListener("focusin", this.onOver)
    document.removeEventListener("focusout", this.onOut)
    window.removeEventListener("scroll", this.onScroll)
    window.removeEventListener("resize", this.onResize)

    clearTimeout(this.hideTimer)
    clearTimeout(this.walkTimer)
    clearTimeout(this.introTimer)
    cancelAnimationFrame(this.frame)
    this.frame = null
    this.y = null
    this.current?.classList.remove(TARGET_CLASS)
    this.current = null
  }

  onOver(event) {
    const block = event.target.closest?.("[data-mascot-fact]")
    if (!block) return

    clearTimeout(this.hideTimer)
    if (block !== this.current) this.show(block)
  }

  onOut(event) {
    if (!this.current || this.current.contains(event.relatedTarget)) return
    // Heading straight into another fact block: onOver takes it from here
    if (event.relatedTarget?.closest?.("[data-mascot-fact]")) return

    // Only ever keep one pending hide. pointerout fires for every element the
    // pointer crosses, and an orphaned timer would hide Ellie mid-hover.
    clearTimeout(this.hideTimer)
    this.hideTimer = setTimeout(() => this.hide(), HIDE_DELAY_MS)
  }

  onScroll() {
    this.mascotTarget.classList.add("is-walking")
    clearTimeout(this.walkTimer)
    this.walkTimer = setTimeout(() => this.mascotTarget.classList.remove("is-walking"), WALK_SETTLE_MS)

    if (this.frame) return
    this.frame = requestAnimationFrame(() => {
      this.frame = null
      this.position()
    })
  }

  show(block) {
    clearTimeout(this.introTimer)
    this.current?.classList.remove(TARGET_CLASS)
    this.current = block
    block.classList.add(TARGET_CLASS)

    this.say(block.dataset.mascotLabel || FACT_LABEL, block.dataset.mascotFact)
    this.position()
  }

  hide() {
    this.current?.classList.remove(TARGET_CLASS)
    this.current = null
    this.quiet()
    this.rest()
  }

  say(label, text) {
    this.labelTarget.textContent = label
    this.textTarget.textContent = text
    this.bubbleTarget.setAttribute("aria-hidden", "false")
    this.mascotTarget.classList.add("is-talking")
  }

  quiet() {
    this.bubbleTarget.setAttribute("aria-hidden", "true")
    this.mascotTarget.classList.remove("is-talking")
  }

  // Line Ellie up with the hovered block, keeping her and her bubble on screen
  position() {
    if (!this.current || !this.wide.matches) return this.rest()

    const rect = this.current.getBoundingClientRect()
    const height = this.mascotTarget.offsetHeight
    const min = this.bubbleTarget.offsetHeight + EDGE_GAP * 2
    const max = window.innerHeight - height - EDGE_GAP
    const level = rect.top + rect.height / 2 - height / 2

    this.moveTo(Math.min(Math.max(level, min), max))
  }

  rest() {
    this.moveTo(window.innerHeight - this.mascotTarget.offsetHeight - EDGE_GAP)
  }

  moveTo(y) {
    y = Math.round(y)
    if (this.y != null && Math.abs(y - this.y) < MIN_MOVE_PX) return

    this.y = y
    this.mascotTarget.style.transform = `translateY(${y}px)`
  }

  // Say hello once per browser session
  introduce() {
    try {
      if (sessionStorage.getItem(INTRO_KEY)) return
      sessionStorage.setItem(INTRO_KEY, "1")
    } catch {
      return
    }

    this.say("Hi, I'm Ellie!", "Hover over anything with a 💡 and I'll tell you a bonus fact.")
    this.introTimer = setTimeout(() => {
      if (!this.current) this.quiet()
    }, INTRO_MS)
  }
}
