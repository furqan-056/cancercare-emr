import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "title", "openIcon", "closeIcon", "label"]

  connect() {
    this.open = true
    this.containerTarget.classList.add("transition-all", "duration-300")
  }

  toggle() {
    this.open = !this.open

    if (this.open) {
      this.containerTarget.classList.remove("w-20")
      this.containerTarget.classList.add("w-64")
      this.titleTarget.classList.remove("hidden")
      this.labelTargets.forEach(label => label.classList.remove("hidden"))
      this.openIconTarget.classList.add("hidden")
      this.closeIconTarget.classList.remove("hidden")
    } else {
      this.containerTarget.classList.remove("w-64")
      this.containerTarget.classList.add("w-20")
      this.titleTarget.classList.add("hidden")
      this.labelTargets.forEach(label => label.classList.add("hidden"))
      this.openIconTarget.classList.remove("hidden")
      this.closeIconTarget.classList.add("hidden")
    }
  }
}
