import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "slide", "dots", "container" ]
  static values = { index: { type: Number, default: 0 }, interval: { type: Number, default: 5000 } }

  connect() {
    this.showSlide()
    this.startAutoAdvance()

    this.containerTarget.addEventListener('mouseenter', this.stopAutoAdvance)
    this.containerTarget.addEventListener('mouseleave', this.startAutoAdvance)
  }

  disconnect() {
    this.stopAutoAdvance()
    this.containerTarget.removeEventListener('mouseenter', this.stopAutoAdvance)
    this.containerTarget.removeEventListener('mouseleave', this.startAutoAdvance)
  }

  indexValueChanged() {
    this.showSlide()
  }

  next() {
    this.indexValue++
    if (this.indexValue >= this.slideTargets.length) {
      this.indexValue = 0
    }
  }

  prev() {
    this.indexValue--
    if (this.indexValue < 0) {
      this.indexValue = this.slideTargets.length - 1
    }
  }

  show(event) {
    this.indexValue = parseInt(event.currentTarget.dataset.index)
    this.stopAutoAdvance()
    this.startAutoAdvance()
  }

  showSlide() {
    this.slideTargets.forEach((slide, index) => {
      const isCurrent = index === this.indexValue
      
      slide.classList.toggle("opacity-100", isCurrent)
      slide.classList.toggle("opacity-0", !isCurrent)
      
      slide.classList.toggle("absolute", !isCurrent)
      slide.classList.toggle("block", isCurrent)

      const dot = this.dotsTarget.children[index]
      if (dot) {
        dot.classList.toggle("opacity-100", isCurrent)
        dot.classList.toggle("ring-2", isCurrent)
        dot.classList.toggle("ring-pink-500", isCurrent)
        dot.classList.toggle("opacity-50", !isCurrent)
      }
    })
  }

  startAutoAdvance = () => {
    this.stopAutoAdvance()
    this.autoAdvanceInterval = setInterval(() => this.next(), this.intervalValue)
  }

  stopAutoAdvance = () => {
    if (this.autoAdvanceInterval) {
      clearInterval(this.autoAdvanceInterval)
      this.autoAdvanceInterval = null
    }
  }
}
