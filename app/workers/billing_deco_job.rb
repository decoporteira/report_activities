class BillingDecoJob
  include Sidekiq::Job

  def perform(*_args)
    today = Time.zone.today

    return if january?(today)

    if today.saturday?
      next_week_day = today + 2.days
      Rails.logger.info "Reagendado para #{next_week_day.strftime('%d/%m/%Y')}."
      BillingDecoJob.perform_at(next_week_day.beginning_of_day)
      return
    elsif today.sunday?
      next_week_day = today + 1.day
      Rails.logger.info "Reagendado para #{next_week_day.strftime('%d/%m/%Y')}."
      BillingDecoJob.perform_at(next_week_day.beginning_of_day)
      return
    end

    set_financial_responsibles.each do |recipient|
      if recipient.email.present?
        BillingFinancialResponsibleMailer.with(recipient:).billing_email.deliver_now
        Rails.logger.info "Email enviado para #{recipient.name} no email: #{recipient.email} e ID: #{recipient.id}"
      else
        Rails.logger.info "Não foi encontrado email para o estudante #{recipient.name} e ID: #{recipient.id}, pulando esse envio."
      end
    end
  end

  private

  def january?(date)
    date.month == 1
  end

  def set_financial_responsibles
    FinancialResponsible.where(id: 1)

  end
end
