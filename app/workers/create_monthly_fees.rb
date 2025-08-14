class CreateMonthlyFees
  include Sidekiq::Job

  def perform(*_args)
    Student.active.find_each(batch_size: 50) do |student|
      next if student.current_plan.nil?

      current_month = Time.zone.today.month
      current_year = Time.zone.today.year
      current_month = current_month == 1 ? 2 : current_month

      Student.transaction do
        next if student.monthly_fees.exists?(due_date: Date.new(current_year, current_month, 10))

        MonthlyFee.create!(
          student:,
          value: student.current_plan.discounted_price,
          due_date: Date.new(current_year, current_month, 10),
          status: 'A pagar'
        )
      end
    end
  end
end
