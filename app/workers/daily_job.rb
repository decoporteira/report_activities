class DailyJob
  include Sidekiq::Job

  def perform(*args)
    monthly_fees = MonthlyFee.where(status: 'A pagar').where('due_date < ?', Date.today)
    monthly_fees.each do |monthly_fee|
      monthly_fee.update(status: 'Atrasada')
      puts "Mensalidade de #{monthly_fee.student.name} foi marcada como #{monthly_fee.status} às #{Time.now}"
    end
  end
end
