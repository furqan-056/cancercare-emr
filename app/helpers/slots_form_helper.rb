module SlotsFormHelper
  def doctor_select_options(form)
    form.collection_select :doctor_id, User.where(type: 'Doctor', organization_id: current_user.organization_id), :id, :first_name, { prompt: "Select Doctor" }, class: "block w-full rounded-xl border border-primary-border shadow-sm text-sm p-3 focus:border-accent-1 focus:ring-accent-1 theme-text-field"
  end

  def weekday_select_options(form)
    form.select :weekday, Slot.weekdays.keys.map { |d| [d.titleize, d] }, { prompt: "Select Day" }, class: "block w-full rounded-xl border border-primary-border shadow-sm text-sm p-3 focus:border-accent-1 focus:ring-accent-1 theme-text-field"
  end
end
