import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["calendarBody", "month", "year", "slotsContainer", "dateInput", "slotInput", "submitBtn", "form"]
  static values = { 
    holidays: String, 
    blocked: String,
    doctorId: Number 
  }

  connect() {
    this.currentDate = new Date()
    this.holidayDates = this.holidaysValue ? this.holidaysValue.split(",") : []
    this.blockedDates = this.blockedValue ? this.blockedValue.split(",") : []
    this.selectedDate = null
    this.selectedSlot = null

    this.renderCalendar()
  }

  renderCalendar() {
    const year = this.currentDate.getFullYear()
    const month = this.currentDate.getMonth()

    this.monthTarget.textContent = this.currentDate.toLocaleString('default', { month: 'long' })
    this.yearTarget.textContent = year

    const firstDay = new Date(year, month, 1).getDay()
    const lastDate = new Date(year, month + 1, 0).getDate()
    const today = new Date().setHours(0, 0, 0, 0)

    let html = ""
    let day = 1

    for (let i = 0; i < 6; i++) {
      for (let j = 0; j < 7; j++) {
        if ((i === 0 && j < firstDay) || day > lastDate) {
          html += '<div class="p-2"></div>'
        } else {
          const fullDate = new Date(year, month, day)
          const dateISO = `${fullDate.getFullYear()}-${String(fullDate.getMonth() + 1).padStart(2, '0')}-${String(fullDate.getDate()).padStart(2, '0')}`
          const isPast = fullDate < today

          let colorClass = "bg-green-300 hover:bg-green-400 cursor-pointer"
          let clickable = true
          let tooltip = ""

          if (isPast) {
            colorClass = "bg-gray-200 cursor-not-allowed"
            clickable = false
            tooltip = "Past date"
          } else if (this.holidayDates.includes(dateISO)) {
            colorClass = "bg-red-400 cursor-not-allowed"
            clickable = false
            tooltip = "Holiday"
          } else if (this.blockedDates.includes(dateISO)) {
            colorClass = "bg-yellow-300 cursor-not-allowed"
            clickable = false
            tooltip = "Doctor Unavailable"
          }

          html += `<div class="p-2 text-center rounded ${colorClass}" 
                        ${clickable ? `data-action="click->calendar#selectDate" data-date="${dateISO}"` : ''}
                        title="${tooltip}">
                     ${day}
                   </div>`
          day++
        }
      }
      if (day > lastDate) break
    }

    this.calendarBodyTarget.innerHTML = html
  }

  async selectDate(event) {
    const date = event.currentTarget.dataset.date
    this.selectedDate = date
    this.selectedSlot = null
    
    this.dateInputTarget.value = date
    this.slotInputTarget.value = ""
    this.submitBtnTarget.disabled = true

    this.calendarBodyTarget.querySelectorAll('[data-date]').forEach(el => {
      el.classList.remove('ring-2', 'ring-blue-500')
    })
    
    event.currentTarget.classList.add('ring-2', 'ring-blue-500')
    await this.loadSlots(date)
  }

  async loadSlots(date) {
    try {
      const url = `/patients/doctors/${this.doctorIdValue}/appointments/available_slots?date=${date}`
      const response = await fetch(url)
      const html = await response.text()
      this.slotsContainerTarget.innerHTML = html
    } catch (error) {
      console.error('Error loading slots:', error)
      this.slotsContainerTarget.innerHTML = '<p class="text-red-500">Error loading slots</p>'
    }
  }

  selectSlot(event) {
    const slotId = event.currentTarget.dataset.slotId
    this.selectedSlot = slotId
    
    this.slotInputTarget.value = slotId
    
    this.slotsContainerTarget.querySelectorAll('[data-slot-id]').forEach(el => {
      el.classList.remove('ring-2', 'ring-blue-600')
    })
    
    event.currentTarget.classList.add('ring-2', 'ring-blue-600')
 
    this.submitBtnTarget.disabled = false
  }

  nextMonth() {
    this.currentDate.setMonth(this.currentDate.getMonth() + 1)
    this.renderCalendar()
  }

  prevMonth() {
    this.currentDate.setMonth(this.currentDate.getMonth() - 1)
    this.renderCalendar()
  }
}
