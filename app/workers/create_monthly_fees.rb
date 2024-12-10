class CreateMonthlyFees
  include Sidekiq::Job

  def perform(*_args)
    Student.active.find_each(batch_size: 50) do |student|
      next if student.current_plan.nil?

      current_month = Time.zone.today.month
      current_year = Time.zone.today.year
      start_month = current_month == 1 ? 2 : current_month

      Student.transaction do
        (start_month..12).each do |month|
          MonthlyFee.create!(
            student:,
            value: student.current_plan.discounted_price,
            due_date: Date.new(current_year, month, 10),
            status: 'A pagar'
          )
        end
      end
    end
  end
end
