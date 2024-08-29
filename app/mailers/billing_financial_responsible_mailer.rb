class BillingFinancialResponsibleMailer < ApplicationMailer
  default from: 'contato@englishglobe.com.br'

  def billing_email
    @recipient = params[:recipient]
    @value = params[:value]
    mail(to: @recipient.email, subject: 'Lembrete de Vencimento da Mensalidade de Responsável Financeiro')
  end
end
