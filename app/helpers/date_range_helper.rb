module DateRangeHelper
  def get_date_range(year)
    case year
    when 2024
      start_date = Date.new(2024, 1, 1)
      end_date = Date.new(2024, 7, 31).end_of_day
    else
      start_date = Date.new(2024, 8, 1)
      end_date = Date.new(2024, 12, 31).end_of_day
    end
    [start_date, end_date]
  end
end
