class BillingResponsiblesJob
  include Sidekiq::Worker

  def perform(*_args)
    today = Time.zone.today

    return if january?(today)

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
    today = Time.zone.today
    case today.day
    when 1
      initial_id = 1
      final_id = 50
    when 2
      initial_id = 50
      final_id = 100
    when 3
      initial_id = 100
      final_id = 150
    when 4
      initial_id = 150
      final_id = 200
    when 5
      initial_id = 200
      final_id = 250
    when 6
      initial_id = 250
      final_id = 300
    end
    responsibles = FinancialResponsible.joins(:responsibles)
                        .where(responsibles: { student_id: Student.where(status: :registered)
                        .pluck(:id) })
                        .distinct
    responsibles.select { |item| item.id > initial_id.to_i && item.id < final_id.to_i }
  end
end
