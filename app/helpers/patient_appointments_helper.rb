module PatientAppointmentsHelper
  STATUS_CLASSES = {
    "requested" => "bg-gray-400 text-white",
    "pending"   => "bg-yellow-400 text-black",
    "approved"  => "bg-green-500 text-white",
    "rejected"  => "bg-red-500 text-white",
    "no_slots"  => "bg-gray-300 text-black"
  }.freeze

  def appointment_status_badge(status)
    return unless status.present?

    bg_class = STATUS_CLASSES[status.to_s] || ""
    
    content_tag(
      :span,
      status.to_s.humanize,
      class: "inline-block px-3 py-1 rounded-full text-xs font-bold mb-4 #{bg_class}"
    )
  end
end
