class DailyJob
  include Sidekiq::Job

  def perform(*args)
    monthly_fees = MonthlyFee.all
    monthly_fees.each do |monthly_fee|
      if monthly_fee.status == 'A pagar'
        monthly_fee.update(status: 'Atrasada')
        puts "Mensalidade de #{monthly_fee.student.name} foi marcada como #{monthly_fee.status} às #{Time.now}"
      else
        puts "Mensalidade de #{monthly_fee.student.name} estava com status: #{monthly_fee.status} paga"
      end
    end
  end
end
