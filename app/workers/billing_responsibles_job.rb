class BillingResponsiblesJob
  include Sidekiq::Worker

  def perform(*_args)
    today = Time.zone.today

    return if january?(today)

    set_financial_responsibles.each do |recipient|
      send_email(recipient)
    end
  end

  private

  def send_email(recipient)
    if recipient.email.present?
      BillingFinancialResponsibleMailer.with(recipient:).billing_email.deliver_now
      Rails.logger.info "Email enviado para #{recipient.name} no email: #{recipient.email} e ID: #{recipient.id}"
    else
      Rails.logger.info "Não foi encontrado email para o estudante #{recipient.name} e ID: #{recipient.id}, "\
                        'pulando esse envio.'
    end
  end

  def january?(date)
    date.month == 1
  end

  def set_financial_responsibles
    ranges = {
      1 => [1, 50],
      2 => [50, 100],
      3 => [100, 150],
      4 => [150, 200],
      5 => [200, 250],
      6 => [250, 300]
    }

    initial_id, final_id = ranges[Time.zone.today.day] || [nil, nil]
    set_reponsibles(initial_id, final_id) if initial_id && final_id
  end

  def set_responsibles(initial_id, final_id)
    responsibles = FinancialResponsible.joins(:responsibles)
                                       .where(responsibles: { student_id: Student.where(status: :registered)
                                        .pluck(:id) }).distinct
    responsibles.select { |item| item.id > initial_id.to_i && item.id < final_id.to_i }
  end
end
