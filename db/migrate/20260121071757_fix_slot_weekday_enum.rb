class FixSlotWeekdayEnum < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      UPDATE slots 
      SET weekday = weekday + 1
      WHERE weekday < 6
    SQL
  end

  def down
    execute <<-SQL
      UPDATE slots 
      SET weekday = weekday - 1
      WHERE weekday > 0
    SQL
  end
end
