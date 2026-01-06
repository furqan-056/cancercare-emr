module AppointmentStatusHelper
  def appointment_status_badge(status, variant: :patient)
    return unless status.present?

    status = status.to_s
    base_classes = ""
    bg_class = ""

    case variant
    when :patient
      base_classes = "inline-block px-3 py-1 rounded-full text-xs font-bold mb-4"
      bg_class = case status
                when "requested" then "bg-gray-400 text-white"
                when "pending"   then "bg-yellow-400 text-black"
                when "approved"  then "bg-green-500 text-white"
                when "rejected"  then "bg-red-500 text-white"
                when "no_slots"  then "bg-gray-300 text-black"
                else ""
                end
    when :manager_modal
      base_classes = "px-2 py-1 rounded-full text-xs font-bold"
      bg_class = case status
                when "requested" then "bg-gray-400/20 text-gray-600"
                when "pending"   then "bg-yellow-400/20 text-yellow-600"
                when "approved"  then "bg-green-500/20 text-green-600"
                when "rejected"  then "bg-red-500/20 text-red-800"
                when "no_slots"  then "bg-gray-300/20 text-gray-800"
                else ""
                end
    when :manager_table
      base_classes = "px-3 py-1 rounded-full text-xs font-bold text-black"
      bg_class = case status
                when "approved"  then "bg-green-500"
                when "rejected"  then "bg-red-500"
                when "pending"   then "bg-yellow-400"
                when "no_slot"   then "bg-yellow-400"
                when "requested" then "bg-gray-400"
                else "bg-gray-400"
                end
    end

    content_tag(:span, status.humanize, class: "#{base_classes} #{bg_class}")
  end
end
