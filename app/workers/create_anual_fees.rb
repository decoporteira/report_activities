class CreateAnualFees
  include Sidekiq::Job

  def perform(*_args)
    Student.active.find_each(batch_size: 50) do |student|
      next if student.current_plan.nil?

      current_year = Time.zone.today.year
      Student.transaction do
        (2..12).each do |month|
          next if student.monthly_fees.exists?(due_date: Date.new(current_year, month, 10))

          create_monthly_fee(student, month, current_year)
        end
      end
    end
  end

  private

  def create_monthly_fee(student, month, current_year)
    MonthlyFee.create!(
      student:,
      value: student.current_plan.discounted_price,
      due_date: Date.new(current_year, month, 10),
      status: 'A pagar'
    )
  end
end
