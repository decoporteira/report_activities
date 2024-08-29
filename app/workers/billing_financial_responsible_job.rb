class BillingFinancialResponsibleJob
  include Sidekiq::Job

  def perform(*_args)
    today = Time.zone.today

    return if january?(today)

    if today.saturday?
      next_week_day = today + 2.days
      Rails.logger.info "Reagendado para #{next_week_day.strftime('%d/%m/%Y')}."
      BillingFinancialResponsibleJob.perform_at(next_week_day.beginning_of_day)
      return
    elsif today.sunday?
      next_week_day = today + 1.day
      Rails.logger.info "Reagendado para #{next_week_day.strftime('%d/%m/%Y')}."
      BillingFinancialResponsibleJob.perform_at(next_week_day.beginning_of_day)
      return
    end

    financial_responsibles = FinancialResponsible.joins(:students).where(students: { status: 1 }).uniq

    financial_responsibles.each do |fr|
      value = 0
      fr.students.each do |student|
        value += 30
        # student.current_plan.plan.price
      end
      BillingFinancialResponsibleMailer.with(recipient: fr, value:).billing_email.deliver_now
      Rails.logger.info "Email enviado para #{fr.email}"
    end
  end

  private

  def january?(date)
    date.month == 1
  end
end
