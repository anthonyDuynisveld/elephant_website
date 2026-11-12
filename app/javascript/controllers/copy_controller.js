import { Controller } from "@hotwired/stimulus"

// A "Copy" button kids can tap to grab a fact or a picture and paste it straight
// into their project. Rendered by the copy_button / copy_picture_button helpers.
//
// Text buttons copy the words of the block the button sits in (the controller
// element's parent): one line per child element, skipping the button itself and
// anything that isn't showing. Picture buttons copy the image at imageValue.
//
// The button is rendered hidden and only revealed when this browser can copy,
// so kids never see a button that does nothing.

const RESET_MS = 2000

export default class extends Controller {
  static targets = ["icon", "label", "status"]
  static values = { image: String }

  connect() {
    this.icon = this.iconTarget.textContent
    this.label = this.labelTarget.textContent
    this.element.hidden = !this.supported
  }

  disconnect() {
    // Turbo caches the page on the way out; don't let it keep a "Copied!" button
    clearTimeout(this.resetTimer)
    this.reset()
  }

  async copy() {
    try {
      await (this.hasImageValue ? this.copyPicture() : navigator.clipboard.writeText(this.text))
      this.show("is-copied", "✅", "Copied!", "Copied! Now paste it into your project.")
    } catch {
      this.show("is-failed", "🙈", "Oops! Try again", "That didn't copy. Please try again.")
    }
  }

  // Safari only allows clipboard.write() straight from the click, so hand it a
  // promise of the picture rather than waiting for the download first
  copyPicture() {
    const png = fetch(this.imageValue)
      .then((response) => {
        if (!response.ok) throw new Error(`Couldn't load ${this.imageValue}`)
        return response.blob()
      })
      .then(toPng)

    return navigator.clipboard.write([new ClipboardItem({ "image/png": png })])
  }

  get text() {
    return Array.from(this.element.parentElement.children)
      .filter((child) => child !== this.element && child.getClientRects().length > 0)
      .map(wordsIn)
      .filter(Boolean)
      .join("\n")
  }

  get supported() {
    const clipboard = navigator.clipboard
    if (!this.hasImageValue) return typeof clipboard?.writeText === "function"

    return typeof clipboard?.write === "function" &&
      typeof ClipboardItem === "function" &&
      (ClipboardItem.supports?.("image/png") ?? true)
  }

  show(state, icon, label, message) {
    clearTimeout(this.resetTimer)
    this.reset()

    this.element.classList.add(state)
    this.iconTarget.textContent = icon
    this.labelTarget.textContent = label
    this.statusTarget.textContent = message

    this.resetTimer = setTimeout(() => this.reset(), RESET_MS)
  }

  reset() {
    this.element.classList.remove("is-copied", "is-failed")
    this.iconTarget.textContent = this.icon
    this.labelTarget.textContent = this.label
    this.statusTarget.textContent = ""
  }
}

// Plain words with tidy spacing. textContent (unlike innerText) ignores CSS such
// as the uppercase stat labels, but it also drops <br>, so swap those for spaces.
// Lists become one "- item" line each instead of running together.
function wordsIn(element) {
  if (element.matches("ul, ol")) {
    return Array.from(element.children)
      .map((item) => wordsIn(item))
      .filter(Boolean)
      .map((words) => `- ${words}`)
      .join("\n")
  }

  const clone = element.cloneNode(true)
  clone.querySelectorAll("br").forEach((br) => br.replaceWith(" "))
  return clone.textContent.replace(/\s+/g, " ").trim()
}

// Clipboards only reliably accept PNG pictures, and our photos are JPEGs
async function toPng(blob) {
  if (blob.type === "image/png") return blob

  const bitmap = await createImageBitmap(blob)
  const canvas = document.createElement("canvas")
  canvas.width = bitmap.width
  canvas.height = bitmap.height
  canvas.getContext("2d").drawImage(bitmap, 0, 0)
  bitmap.close()

  return new Promise((resolve, reject) => {
    canvas.toBlob((png) => (png ? resolve(png) : reject(new Error("Couldn't make a PNG"))), "image/png")
  })
}
