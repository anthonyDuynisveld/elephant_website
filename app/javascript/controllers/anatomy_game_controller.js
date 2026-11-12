import { Controller } from "@hotwired/stimulus"

// "Find the part" quiz. Each round names one part of the elephant; the player clicks
// (or tabs to and presses Enter on) the matching part of the picture. A wrong guess can
// be retried, and the score counts only parts found on the first try.
export default class extends Controller {
  static targets = ["part", "prompt", "feedback", "fact", "next", "score", "progress", "board", "summary", "result", "start"]
  static values = { rounds: { type: Number, default: 8 } }

  connect() {
    this.parts = this.partTargets.map((el) => ({ id: el.dataset.part, name: el.dataset.name, fact: el.dataset.fact }))
    this.current = null
    this.boardTarget.hidden = true
    this.summaryTarget.hidden = true
    this.startTarget.hidden = false
  }

  start() {
    this.queue = this.shuffle(this.parts).slice(0, this.roundsValue)
    this.round = 0
    this.score = 0
    this.startTarget.hidden = true
    this.summaryTarget.hidden = true
    this.boardTarget.hidden = false
    this.nextRound()
  }

  nextRound() {
    this.clearMarks()
    this.current = this.queue[this.round]
    this.missed = false
    this.answered = false
    this.promptTarget.textContent = `Can you find the elephant's ${this.current.name.toLowerCase()}?`
    this.feedbackTarget.textContent = ""
    this.feedbackTarget.className = "game-feedback"
    this.factTarget.textContent = ""
    this.nextTarget.hidden = true
    this.progressTarget.textContent = `Question ${this.round + 1} of ${this.queue.length}`
    this.scoreTarget.textContent = `⭐ ${this.score}`
  }

  guess(event) {
    if (event.type === "keydown" && event.key !== "Enter" && event.key !== " ") return
    event.preventDefault()
    if (this.answered || !this.current) return

    const el = event.currentTarget
    if (el.dataset.part === this.current.id) {
      this.answered = true
      el.classList.add("is-correct")
      if (!this.missed) this.score += 1
      this.scoreTarget.textContent = `⭐ ${this.score}`
      this.feedbackTarget.className = "game-feedback is-right"
      this.feedbackTarget.textContent = this.missed ? "You found it! 🎉" : "Yes! Great job! 🎉"
      this.factTarget.textContent = `Did you know? ${this.current.fact}`
      this.nextTarget.textContent = this.round + 1 >= this.queue.length ? "See my score" : "Next question ➜"
      this.nextTarget.hidden = false
      this.nextTarget.focus()
    } else {
      this.missed = true
      el.classList.remove("is-wrong")
      void el.getBoundingClientRect() // restart the shake if the same part is tapped twice
      el.classList.add("is-wrong")
      this.feedbackTarget.className = "game-feedback is-wrong"
      this.feedbackTarget.textContent = `That's the ${el.dataset.name.toLowerCase()}. Try again!`
    }
  }

  next() {
    this.round += 1
    if (this.round >= this.queue.length) return this.finish()
    this.nextRound()
  }

  finish() {
    this.clearMarks()
    this.current = null
    this.boardTarget.hidden = true
    this.summaryTarget.hidden = false
    this.nextTarget.hidden = true
    this.feedbackTarget.textContent = ""
    this.factTarget.textContent = ""
    const total = this.queue.length
    const praise = this.score === total ? "Perfect! You're an elephant expert! 🐘"
      : this.score >= total * 0.6 ? "Great work! Almost an expert!"
      : "Good try! Play again to learn more."
    this.resultTarget.textContent = `You found ${this.score} out of ${total} on the first try. ${praise}`
    this.summaryTarget.querySelector("button").focus()
  }

  clearMarks() {
    this.partTargets.forEach((el) => el.classList.remove("is-correct", "is-wrong"))
  }

  shuffle(list) {
    const a = [...list]
    for (let i = a.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [a[i], a[j]] = [a[j], a[i]]
    }
    return a
  }
}
