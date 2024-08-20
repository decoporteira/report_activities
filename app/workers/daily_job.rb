class DailyJob
  include Sidekiq::Job

  def perform(*args)
    monthly_fees =
      MonthlyFee.where(status: 'A pagar').where('due_date < ?', Date.today)
    monthly_fees.each { |monthly_fee| monthly_fee.update(status: 'Atrasada') }
  end
end
