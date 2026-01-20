import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["date", "slot", "doctor"]

  connect() {
    this.updateSlots()
    this.dateTarget.addEventListener("change", () => this.updateSlots())
    this.doctorTarget.addEventListener("change", () => this.updateSlots())
  }

  updateSlots() {
    const date = this.dateTarget.value
    const doctorId = this.doctorTarget.value

    const options = this.slotTarget.querySelectorAll("option")

    if (!date) {
      options.forEach(option => option.hidden = false)
      return
    }

    const jsDay = new Date(date).getDay()
    const jsToRailsWeekday = [6, 0, 1, 2, 3, 4, 5]
    const weekday = jsToRailsWeekday[jsDay]

    options.forEach(option => {
      const optionWeekday = parseInt(option.dataset.weekday)
      const optionDoctor = option.dataset.doctorId

      const show = optionWeekday === weekday && (!doctorId || optionDoctor == doctorId)
      option.hidden = !show
    })

    if (this.slotTarget.selectedOptions[0]?.hidden) {
      this.slotTarget.selectedIndex = 0
    }
  }
}
