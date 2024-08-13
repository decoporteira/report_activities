class BillingMailer < ApplicationMailer
  default from: 'contato@englishglobe.com.br'

  def billing_email
    @billing = params[:billing]
    mail(to: @billing.email, subject: 'Lembrete de Vencimento da Mensalidade')
  end
end
