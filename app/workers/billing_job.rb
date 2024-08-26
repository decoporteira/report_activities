class BillingJob
  include Sidekiq::Job

  def perform(*_args)
    today = Time.zone.today

    return if january?(today)

    if today.saturday?
      next_week_day = today + 2.days
      Rails.logger.info "Reagendado para #{next_week_day.strftime('%d/%m/%Y')}."
      BillingJob.perform_at(next_week_day.beginning_of_day)
      return
    elsif today.sunday?
      next_week_day = today + 1.day
      Rails.logger.info "Reagendado para #{next_week_day.strftime('%d/%m/%Y')}."
      BillingJob.perform_at(next_week_day.beginning_of_day)
      return
    end

    students = Student.where(status: :registered)

    students.each do |student|
      recipient = student.financial_responsibles.blank? ? student : student.financial_responsibles.first

      if recipient.email.present?
        recipient = Student.find(1)
        BillingMailer.with(recipient:).billing_email.deliver_now
        Rails.logger.info "Email enviado para #{recipient.name}"
        return
      else
        Rails.logger.info "Não foi encontrado email para o estudante com ID = #{student.id}, pulando esse envio."
      end
    end
  end

  private

  def january?(date)
    date.month == 1
  end
end
