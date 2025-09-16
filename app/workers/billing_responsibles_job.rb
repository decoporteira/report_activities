class BillingResponsiblesJob
  include Sidekiq::Job

  def perform(*_args)
    target_date = next_business_day(Date.new(Time.zone.today.year, Time.zone.today.month, 11))

    monthly_fees = MonthlyFee.where(status: 'A pagar')
                             .where('due_date <= ?', target_date)

    monthly_fees.each do |monthly_fee|
      monthly_fee.update(status: 'Atrasada')
    end
  end

  private

  def next_business_day(date)
    case date.wday
    when 6 then date + 2
    when 0 then date + 1
    else date
    end
  end
end
