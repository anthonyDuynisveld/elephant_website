import { Controller } from "@hotwired/stimulus"

// Plays the video while the card is hovered or focused, then pauses and
// rewinds to the first frame (the poster) when the pointer leaves.
export default class extends Controller {
  static targets = ["video"]

  play() {
    if (!this.hasVideoTarget) return
    this.videoTarget.play().catch(() => {})
  }

  reset() {
    if (!this.hasVideoTarget) return
    this.videoTarget.pause()
    this.videoTarget.currentTime = 0
  }
}
