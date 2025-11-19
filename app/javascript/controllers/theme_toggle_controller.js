import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["moonIcon", "sunIcon"]

  connect() {
    this._applyTheme(localStorage.theme)
  }

  toggle() {
    const isLight = document.documentElement.classList.contains("light")
    const newTheme = isLight ? "dark" : "light"
    
    this._applyTheme(newTheme)
  }
  
  _applyTheme(themePreference) {
    if (themePreference === "light") {
      document.documentElement.classList.add("light")
      localStorage.theme = "light"
      this.moonIconTarget.classList.add("hidden")
      this.sunIconTarget.classList.remove("hidden")
    } else {
      document.documentElement.classList.remove("light")
      localStorage.theme = "dark"
      this.moonIconTarget.classList.remove("hidden")
      this.sunIconTarget.classList.add("hidden")
    }
  }
}
