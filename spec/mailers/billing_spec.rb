require 'rails_helper'

RSpec.describe BillingMailer, type: :mailer do
  describe '#billing_email' do
    let(:recipient) { FactoryBot.create(:student, name: 'Ash') }
    let(:mail) { BillingMailer.with(recipient: recipient).billing_email }

    it 'renders the headers' do
      expect(mail.subject).to eq('Lembrete de Vencimento da Mensalidade')
      expect(mail.to).to eq([recipient.email])
      expect(mail.from).to eq(['no-reply@reports.englishglobe.com.br'])
    end

    it 'renders the HTML body' do
      month_name = I18n.t('date.month_names')[Time.zone.today.month]
      formatted_date = Date.today.strftime('%d/%m/%Y')

      html_body = mail.body.parts.find { |part| part.content_type =~ /html/ }.body.decoded
      expect(html_body).to include("Este é um e-mail automático para lembrá-lo(a) de que a sua mensalidade da")
      expect(html_body).to include("English Globe referente ao mês de #{month_name}, está próxima do vencimento,")
      expect(html_body).to include("no dia 10/#{Date.today.strftime('%m/%Y')}.")
      expect(html_body).to include("Olá, Ash,")
      expect(html_body).to include("Agradecemos pela sua atenção e desejamos um excelente dia!")
    end

    it 'renders the plain text body' do
      month_name = I18n.t('date.month_names')[Time.zone.today.month]
      formatted_date = Date.today.strftime('%d/%m/%Y')
      expected_body_content = "Este é um e-mail automático para lembrá-lo(a) de que a sua mensalidade da English Globe referente ao mês de #{month_name}, vence hoje, #{formatted_date}"

      text_body = mail.body.parts.find { |part| part.content_type =~ /plain/ }.body.decoded
      expect(text_body).to include(expected_body_content)
      expect(text_body).to include("Olá, Ash,")
      expect(text_body).to include("Agradecemos pela sua atenção e desejamos um excelente dia!")
    end
  end
end
