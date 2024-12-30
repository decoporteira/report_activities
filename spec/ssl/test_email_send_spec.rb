require 'rails_helper'

RSpec.describe 'SSL Connection', type: :request do
  describe 'SMTP SSL Connection' do
    # it 'sends an email successfully' do
    #   # Antes de enviar o e-mail, limpa a fila de e-mails para garantir um teste limpo
    #   ActionMailer::Base.deliveries.clear

    #   # Enviar o e-mail
    #   Net::SMTP.start(
    #     'smtp.gmail.com',
    #     587,
    #     'mail.google.com',
    #     'naoresponda.englishglobe@gmail.com',
    #     'kbsd bzkp cktr uodl',
    #     :plain
    #   ) do |smtp|
    #     smtp.enable_starttls
    #     smtp.open_message_stream('naoresponda.englishglobe@gmail.com', ['andreporteira@gmail.com']) do |f|
    #       f.puts 'Subject: Testing Email'
    #       f.puts
    #       f.puts 'This is a test email.'
    #     end
    #   end

    #   # Verificar se o e-mail foi enviado
    #   expect(ActionMailer::Base.deliveries.count).to eq(1)
    #   expect(ActionMailer::Base.deliveries.last.subject).to eq('Test Email')
    #   expect(ActionMailer::Base.deliveries.last.to).to eq(['andreporteira@gmail.com'])
    #   expect(ActionMailer::Base.deliveries.last.body).to include('This is a test email.')
    # end

    # it 'raises an error when incorrect SSL version is used' do
    #   # Adjust based on the actual error raised
    #   expect do
    #     Net::SMTP.start(
    #       'smtp.gmail.com',
    #       587,
    #       'mail.google.com',
    #       'naoresponda.englishglobe@gmail.com',
    #       'kbsd bzkp cktr uodl',
    #       :plain
    #     ) do |smtp|
    #       smtp.enable_starttls
    #       smtp.open_message_stream('naoresponda.englishglobe@gmail.com', ['andreporteira@gmail.com']) do |f|
    #         f.puts 'Subject: Test Email'
    #         f.puts
    #         f.puts 'This is a test email.'
    #       end
    #     end
    #   end.to raise_error(Net::OpenTimeout)
    # end

    # it 'raises an error when incorrect SSL version is used' do
    #   expect do
    #     Net::SMTP.start(
    #       'smtp.gmail.com',
    #       587,
    #       'mail.google.com',
    #       'naoresponda.englishglobe@gmail.com', # Email correto
    #       'senha_incorreta', # Senha incorreta para gerar erro
    #       :plain
    #     ) do |smtp|
    #       smtp.enable_starttls
    #       smtp.open_message_stream('naoresponda.englishglobe@gmail.com', ['andreporteira@gmail.com']) do |f|
    #         f.puts 'Subject: Test new Email'
    #         f.puts
    #         f.puts 'This is a new test email.'
    #       end
    #     end
    #   end.to raise_error(Net::SMTPAuthenticationError) # Espera um erro de autenticação
    # end

    # it 'ensures proper SSL settings are applied' do
    #   smtp = Net::SMTP.new('smtp.gmail.com', 587)
    #   smtp.enable_starttls_auto
    #   expect(smtp).to respond_to(:enable_starttls_auto)
    # end
  end
end
