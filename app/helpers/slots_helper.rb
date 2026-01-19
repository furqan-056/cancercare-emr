module SlotsHelper
  def weekdays_for_table
    Slot.weekdays.keys.map(&:to_s).unshift("sunday").uniq
  end

  def slots_for_day_time(slots, day, time_range)
    slots.select do |s|
      s.weekday.to_s == day.to_s &&
        "#{s.start_time.strftime('%H:%M')} - #{s.end_time.strftime('%H:%M')}" == time_range
    end
  end

  def render_all_slots_td(slots, day, time_range)
    slots_for_day = slots_for_day_time(slots, day, time_range)

    content_tag :td, class: "p-3 border border-primary-border align-top bg-primary-bg", id: "slot_row_#{day}_#{time_range.parameterize}" do
      safe_join(slots_for_day.map { |slot| render partial: "slot_row", locals: { slot: slot } })
    end
  end

  def prepare_slots_for_table(slots, display_limit: 3)
    all_slots = slots.order(:start_time)
    time_ranges = all_slots.map { |s| "#{s.start_time.strftime('%H:%M')} - #{s.end_time.strftime('%H:%M')}" }.uniq

    {
      all_slots: all_slots,
      time_ranges: time_ranges,
      display_limit: display_limit
    }
  end

  def render_slots_td(slots, day, time_range, display_limit: 3)
    slots_for_day = slots_for_day_time(slots, day, time_range)

    content_tag :td, class: "p-3 border border-primary-border align-top bg-primary-bg", id: "slot_row_#{day}_#{time_range.parameterize}" do

      safe_join(slots_for_day.first(display_limit).map do |slot|
        render partial: "slot_row", locals: { slot: slot }
      end) +

      if slots_for_day.size > display_limit
        content_tag(:div, x_data: "{ open: false }", class: "mt-1") do
          button = content_tag(:button, "+#{slots_for_day.size - display_limit} more", class: "text-xs text-accent-1 font-medium focus:outline-none", **{ "@click" => "open = !open" })
          extra_slots = content_tag(:div, class: "mt-1 space-y-1", **{ "x-show" => "open", "x-transition" => true }) do
            safe_join(slots_for_day.drop(display_limit).map { |slot| render partial: "slot_row", locals: { slot: slot } })
          end
          button + extra_slots
        end
      else
        "".html_safe
      end
    end
  end
end
