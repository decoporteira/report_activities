require 'rails_helper'

RSpec.describe BillingMailer, type: :mailer do
  # it 'renders the headers' do
  #   recipient = create(:student, email: 'student@example.com', name: 'Ash', status: :registered)
  #   mail = BillingMailer.with(recipient:).billing_email
  #   expect(mail.subject).to eq('Lembrete de Vencimento da Mensalidade')
  #   expect(mail.to).to eq([recipient.email])
  #   expect(mail.from).to eq(['no-reply@reports.englishglobe.com.br'])
  # end
  # it 'renders the HTML body' do
  #   recipient = create(:student, email: 'student@example.com', name: 'Ash', status: :registered)
  #   mail = BillingMailer.with(recipient:).billing_email
  #   month_name = I18n.t('date.month_names')[Time.zone.today.month]
  #   Time.zone.today.strftime('%d/%m/%Y')
  #   expected_body_content = 'Este é um e-mail automático para lembrá-lo(a) de que a sua mensalidade da ' \
  #   "English Globe referente ao mês de #{month_name}, está próxima do vencimento, " \
  #   "no dia 10/#{Time.zone.today.strftime('%m/%Y')}.".strip
  #   html_body = mail.body.parts.find { |part| part.content_type =~ /html/ }.body.decoded
  #   expect(html_body).to include(expected_body_content)
  #   expect(html_body).to include('Olá, Ash,')
  #   expect(html_body).to include('Agradecemos pela sua atenção e desejamos um excelente dia!')
  # end
  # it 'renders the plain text body' do
  #   recipient = create(:student, email: 'student@example.com', name: 'Ash', status: :registered)
  #   mail = BillingMailer.with(recipient:).billing_email
  #   month_name = I18n.t('date.month_names')[Time.zone.today.month]
  #   formatted_date = Time.zone.today.strftime('%d/%m/%Y')
  #   expected_body_content = 'Este é um e-mail automático para lembrá-lo(a) de que a sua mensalidade da ' \
  #   "English Globe referente ao mês de #{month_name}, vence hoje, #{formatted_date}"
  #   text_body = mail.body.parts.find { |part| part.content_type =~ /plain/ }.body.decoded
  #   expect(text_body).to include(expected_body_content)
  #   expect(text_body).to include('Olá, Ash,')
  #   expect(text_body).to include('Agradecemos pela sua atenção e desejamos um excelente dia!')
  # end
end
