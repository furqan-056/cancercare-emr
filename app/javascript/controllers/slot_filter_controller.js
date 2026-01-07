import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slots"]

  filter(event) {
    const selectedDoctorId = event.target.value

    this.slotsTarget.querySelectorAll("option").forEach(option => {
      if (option.value === "" || option.dataset.doctorId === selectedDoctorId) {
        option.hidden = false
      } else {
        option.hidden = true
      }
    })
  }
}
