module AppointmentStatusHelper
  def appointment_status_badge(status, variant: :patient)
    return unless status.present?
    
    status = status.to_s
    
    base_classes = case variant
                   when :patient then "inline-block px-3 py-1 rounded-full text-xs font-bold mb-4"
                   when :manager_modal then "px-2 py-1 rounded-full text-xs font-bold"
                   when :manager_table then "px-3 py-1 rounded-full text-xs font-bold text-black"
                   else ""
                   end
    
    bg_class = case [variant, status]
               when [:patient, "requested"] then "bg-gray-400 text-white"
               when [:patient, "pending"] then "bg-yellow-400 text-black"
               when [:patient, "approved"] then "bg-green-500 text-white"
               when [:patient, "rejected"] then "bg-red-500 text-white"
               when [:patient, "no_slots"] then "bg-gray-300 text-black"
               when [:manager_modal, "requested"] then "bg-gray-400/20 text-gray-600"
               when [:manager_modal, "pending"] then "bg-yellow-400/20 text-yellow-600"
               when [:manager_modal, "approved"] then "bg-green-500/20 text-green-600"
               when [:manager_modal, "rejected"] then "bg-red-500/20 text-red-800"
               when [:manager_modal, "no_slots"] then "bg-gray-300/20 text-gray-800"
               when [:manager_table, "approved"] then "bg-green-500"
               when [:manager_table, "rejected"] then "bg-red-500"
               when [:manager_table, "pending"], [:manager_table, "no_slot"] then "bg-yellow-400"
               when [:manager_table, "requested"] then "bg-gray-400"
               else variant == :manager_table ? "bg-gray-400" : ""
               end
    
    content_tag(:span, status.humanize, class: "#{base_classes} #{bg_class}")
  end
end
