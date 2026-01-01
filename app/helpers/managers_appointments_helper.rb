module ManagersAppointmentsHelper
  STATUS_CLASSES = {
    modal: {
      "requested" => "bg-gray-400/20 text-gray-600",
      "pending"   => "bg-yellow-400/20 text-yellow-600",
      "approved"  => "bg-green-500/20 text-green-600",
      "rejected"  => "bg-red-500/20 text-red-800",
      "no_slots"  => "bg-gray-300/20 text-gray-800"
    },
    table: {
      "approved"  => "bg-green-500",
      "rejected"  => "bg-red-500",
      "pending"   => "bg-yellow-400",
      "no_slot"   => "bg-yellow-400",
      "requested" => "bg-gray-400",
      nil         => "bg-gray-400"
    }
  }.freeze

  def manager_appointment_status_badge(status, style = :modal)
    return unless status.present?

    bg_class = STATUS_CLASSES[style][status.to_s] || STATUS_CLASSES[style][nil]
    padding_classes = style == :modal ? "px-2 py-1" : "px-3 py-1"

    content_tag(
      :span,
      status.to_s.humanize,
      class: "#{padding_classes} rounded-full text-xs font-bold #{style == :table ? 'text-black' : ''} #{bg_class}"
    )
  end
end
