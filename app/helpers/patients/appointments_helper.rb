module Patients::AppointmentsHelper
  def appointment_status_meta(status)
    case status
    when "pending"
      { classes: "bg-accent-2/20 text-accent-3 border-accent-2/30 text-secondary-text",
        icon: "fa-hourglass-half" }
    when "approved"
      { classes: "bg-green-500/20 text-green-400 border-green-500/30 text-secondary-text",
        icon: "fa-check-circle" }
    when "rejected"
      { classes: "bg-red-500/20 text-red-400 border-red-500/30 text-secondary-text",
        icon: "fa-circle-xmark" }
    else
      { classes: "bg-gray-200 text-gray-500 border-gray-300",
        icon: "fa-circle-question" }
    end
  end
end
