import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  connect() {
    const current = window.location.pathname

    this.linkTargets.forEach(link => {
      if (link.getAttribute("href") === current) {
        link.classList.add("bg-hover-bg")
        link.classList.add("text-primary-text")
      }
    })
  }
}
