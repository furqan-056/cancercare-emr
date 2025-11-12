import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { duration: Number }

  connect() {
    const duration = this.hasDurationValue ? this.durationValue : 3000
    this.autoHide(duration)
  }

  autoHide(duration) {
    setTimeout(() => {
      this.element.classList.add("animate-fade-out")
    }, duration)

    setTimeout(() => {
      this.element.remove()
    }, duration + 1000)
  }

  close() {
    this.element.remove()
  }
}
