module Patients::AvailableSlotsHelper
  def slot_button_props(slot, selected_date)
    slot_blocked = SlotException.where(slot_id: slot[:id], exception_date: selected_date).exists?
    is_available = slot[:available] && !slot_blocked

    state_classes = if slot_blocked
                      "bg-orange-50 border-orange-200 text-orange-800 cursor-not-allowed opacity-90"
                    elsif !slot[:available]
                      "bg-red-50 border-red-200 text-red-800 cursor-not-allowed opacity-90"
                    else
                      "bg-white border-green-200 text-green-900 hover:border-green-500 hover:shadow-md cursor-pointer"
                    end

    {
      slot_blocked: slot_blocked,
      is_available: is_available,
      state_classes: state_classes
    }
  end
end
