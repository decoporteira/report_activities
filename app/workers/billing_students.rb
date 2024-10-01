class BillingStudents
  include Sidekiq::Job

  def perform(*_args)
    today = Time.zone.today

    return if january?(today)

    if today.saturday?
      next_week_day = today + 2.days
      Rails.logger.info "Reagendado para #{next_week_day.strftime('%d/%m/%Y')}."
      BillingStudents.perform_at(next_week_day.beginning_of_day)
      return
    elsif today.sunday?
      next_week_day = today + 1.day
      Rails.logger.info "Reagendado para #{next_week_day.strftime('%d/%m/%Y')}."
      BillingStudents.perform_at(next_week_day.beginning_of_day)
      return
    end
    students_without_responsible = Student.left_outer_joins(:responsibles).where(responsibles: { id: nil })
    students_without_responsible = students_without_responsible.where(status: :registered)
    students_without_responsible.each do |recipient|

      if recipient.email.present?
        if recipient.id.to_i.even?
          BillingMailer.with(recipient:).billing_email.deliver_now
          Rails.logger.info "Email enviado para #{recipient.name} (Estudante: #{recipient.name}, ID: #{recipient.id}), no email: #{recipient.email}"
        else
          Rails.logger.info "Reagendado para #{next_week_day.strftime('%d/%m/%Y')}."
          BillingStudents.perform_at(next_week_day.beginning_of_day)
        end
      else
        Rails.logger.info "Não foi encontrado email para o estudante #{recipient.name}, pulando esse envio."
      end
    end
  end

  private

  def january?(date)
    date.month == 1
  end
end
