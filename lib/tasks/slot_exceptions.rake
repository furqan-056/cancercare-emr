namespace :slot_exceptions do
  desc "Seed Pakistan public holidays as global slot exceptions"
  task seed_holidays: :environment do
    year = ENV['YEAR']&.to_i || Date.today.year

    holidays = {
      Date.new(year, 1, 1)   => "New Year's Day",
      Date.new(year, 3, 23)  => "Pakistan Day",
      Date.new(year, 5, 1)   => "Labour Day",
      Date.new(year, 8, 14)  => "Independence Day",
      Date.new(year, 9, 6)   => "Defence Day",
      Date.new(year, 12, 25) => "Quaid-e-Azam Day"
    }

    holidays.each do |date, reason|
      slot_exception = SlotException.find_or_initialize_by(
        exception_date: date,
        exception_type: :holiday
      )

      slot_exception.reason = reason
      if slot_exception.save
        puts "Created/Updated holiday: #{reason} (#{date})"
      else
        puts "Failed for #{reason} (#{date}): #{slot_exception.errors.full_messages.join(', ')}"
      end
    end
  end
end
