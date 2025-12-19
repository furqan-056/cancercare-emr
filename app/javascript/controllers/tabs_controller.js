import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const defaultTab = "appointments"

    this.activateTab(defaultTab)
  }

  toggle(event) {
    const tab = event.currentTarget.dataset.tabTarget
    this.activateTab(tab)
  }

  activateTab(tab) {
    document.querySelectorAll(".tab-content").forEach(el =>
      el.classList.add("hidden")
    )

    this.element
      .querySelectorAll("button[data-tab-target]")
      .forEach(btn => {
        btn.classList.remove(
          "bg-primary-bg",
          "shadow-md",
          "scale-105"
        )
      })

    document
      .getElementById(`${tab}-content`)
      ?.classList.remove("hidden")

    const activeButton = this.element.querySelector(
      `button[data-tab-target="${tab}"]`
    )

    activeButton?.classList.add(
      "bg-primary-bg",
      "shadow-md",
      "scale-105"
    )

    const appointmentBtn = document.getElementById("create-appointment-btn")
    const slotBtn = document.getElementById("create-slot-btn")

    if (appointmentBtn && slotBtn) {
      appointmentBtn.classList.toggle("hidden", tab !== "appointments")
      slotBtn.classList.toggle("hidden", tab !== "slots")
    }
  }
}
