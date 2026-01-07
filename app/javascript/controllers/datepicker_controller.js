import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  connect() {
    this.picker = flatpickr(this.element, {
      enableTime: true,
      dateFormat: "Y-m-d h:i K",
      time_24hr: false,
      minDate: "today",
      allowInput: true,

      onReady: (selectedDates, dateStr, instance) => {
        this.addDoneButton(instance)
      }
    })
  }

  addDoneButton(instance) {
    const button = document.createElement("button")
    button.type = "button"
    button.textContent = "Done"

    button.className =
      "mt-3 w-full rounded-lg bg-accent-1 px-4 py-2 text-sm font-medium text-primary-text hover:bg-accent-1-hover transition"

    button.addEventListener("click", () => {
      instance.close()
    })

    instance.calendarContainer.appendChild(button)
  }
}
