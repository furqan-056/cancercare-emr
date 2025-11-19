import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["moonIcon", "sunIcon"]

  connect() {
    if (localStorage.theme === "light") {
      document.documentElement.classList.add("light")
      this.moonIconTarget.classList.add("hidden")
      this.sunIconTarget.classList.remove("hidden")
    } else {
      document.documentElement.classList.remove("light")
      this.moonIconTarget.classList.remove("hidden")
      this.sunIconTarget.classList.add("hidden")
    }
  }

  toggle() {
    document.documentElement.classList.toggle("light")

    if (document.documentElement.classList.contains("light")) {
      localStorage.theme = "light"
      this.moonIconTarget.classList.add("hidden")
      this.sunIconTarget.classList.remove("hidden")
    } else {
      localStorage.theme = "dark"
      this.moonIconTarget.classList.remove("hidden")
      this.sunIconTarget.classList.add("hidden")
    }
  }
}
