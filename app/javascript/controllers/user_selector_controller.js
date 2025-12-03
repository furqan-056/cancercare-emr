import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["existingUser", "emailField"]

  existingUserChanged() {
    if (this.existingUserTarget.value) {
      this.emailFieldTarget.value = ""
      this.emailFieldTarget.disabled = true
    } else {
      this.emailFieldTarget.disabled = false
    }
  }

  emailChanged() {
    if (this.emailFieldTarget.value.length > 0) {
      this.existingUserTarget.value = ""
      this.existingUserTarget.disabled = true
    } else {
      this.existingUserTarget.disabled = false
    }
  }
}
