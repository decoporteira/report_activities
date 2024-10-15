class BillingStudentsOddJob
  include Sidekiq::Job

  def perform(*_args)
    today = Time.zone.today

    return if january?(today)

    if weekend?(today)
      reschedule_job(today)
    else
      send_billing_emails_for_odd_students
    end
  end

  private

  def weekend?(today)
    today.saturday? || today.sunday?
  end

  def reschedule_if_weekend(today)
    if today.saturday?
      reschedule_job(today, 2)
    elsif today.sunday?
      reschedule_job(today, 1)
    end
  end

  def reschedule_job(today, days_to_add)
    next_week_day = today + days_to_add.days
    Rails.logger.info "Reagendado para #{next_week_day.strftime('%d/%m/%Y')}."
    BillingStudentsOddJob.perform_at(next_week_day.beginning_of_day)
  end

  def send_billing_emails_for_odd_students
    set_student.select { |student| student.id.odd? }.each do |student|
      if student.email.present?
        send_billing_email(student)
      else
        log_missing_email(student)
      end
    end
  end

  def send_billing_email(student)
    BillingMailer.with(recipient: student).billing_email.deliver_now
    Rails.logger.info "Email enviado para #{student.name} (Estudante: #{student.name}, ID: #{student.id}), " \
                      "no email: #{student.email}"
  end

  def log_missing_email(student)
    Rails.logger.info "Não foi encontrado email para o estudante #{student.name} e id: #{student.id}, " \
                      'pulando esse envio.'
  end

  def set_student
    students_without_responsible = Student.left_outer_joins(:responsibles).where(responsibles: { id: nil })
    students_without_responsible.where(status: :registered)
  end

  def january?(date)
    date.month == 1
  end
end
