module DateRangeHelper
  def get_date_range(last_semester)
    if last_semester
      start_date, end_date = set_last_semester
    else
      start_date, end_date = set_current_semester
    end
    [start_date, end_date]
  end

  def set_last_semester
    if Time.zone.today.month.between?(1, 6)
      start_date = Date.new(Time.zone.today.year - 1, 8, 1)
      end_date = Date.new(Time.zone.today.year - 1, 12, 31).end_of_day
    else
      start_date = Date.new(Time.zone.today.year, 1, 1)
      end_date = Date.new(Time.zone.today.year, 7, 30).end_of_day
    end
    [start_date, end_date]
  end

  def set_current_semester
    if Time.zone.today.month.between?(1, 6)
      start_date = Date.new(Time.zone.today.year, 1, 1)
      end_date = Date.new(Time.zone.today.year, 7, 30).end_of_day
    else
      start_date = Date.new(Time.zone.today.year, 8, 1)
      end_date = Date.new(Time.zone.today.year, 12, 31).end_of_day
    end
    [start_date, end_date]
  end
end
