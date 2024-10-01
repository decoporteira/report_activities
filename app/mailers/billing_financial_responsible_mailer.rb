class BillingFinancialResponsibleMailer < ApplicationMailer
  default from: 'English Globe <no-reply@reports.englishglobe.com.br>'

  def billing_email
    @recipient = params[:recipient]
    mail(to: @recipient.email, subject: 'Lembrete de Vencimento da Mensalidade')
  end
end
