module DoctorsAppointmentsHelper
  def slot_options_for_select(slots, appointment)
    slots.map do |slot|
      selected = appointment.slot_id == slot.id ? "selected" : ""
      content_tag(:option, "#{slot.start_time.strftime("%B %d, %Y at %I:%M %p")} — #{slot.doctor.full_name}".html_safe,value: slot.id, data: { doctor_id: slot.doctor_id }, selected: selected.presence)
    end.join("\n").html_safe
  end
end
