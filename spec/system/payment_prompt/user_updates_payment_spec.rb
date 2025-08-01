# spec/system/payment_prompt_spec.rb
require 'rails_helper'

RSpec.describe "Payment prompt", type: :system, js: true  do
  before do
    # Configure os dados necessários
    @plan = create(:plan)
    @student = create(:student, current_plan: create(:current_plan, plan: @plan))
    @monthly_fee = create(:monthly_fee, student: @student)

    visit monthly_fees_path # ou qualquer path que renderize o HTML com o Stimulus
  end

  it "exibe o prompt e envia o formulário quando o plano é válido" do
    # Altere o valor diretamente via JS para evitar depender da seed exata
    page.execute_script <<~JS
      const button = document.querySelector('[data-controller="payment"]');
      button.dataset.paymentPlanValue = "4";
      button.dataset.paymentValorValue = "100";
    JS

    # Mock do prompt do navegador
    page.accept_prompt(with: '120') do
      find('[data-controller="payment"]').click
    end

    # Espera o campo hidden ser inserido e o form enviado
    expect(page).to have_current_path(/update_paid/) # ou a URL de destino
  end

  it "não exibe o prompt nem envia o form para planos 1, 2 ou 3" do
    page.execute_script <<~JS
      const button = document.querySelector('[data-controller="payment"]');
      button.dataset.paymentPlanValue = "1";
      button.dataset.paymentValorValue = "100";
    JS

    find('[data-controller="payment"]').click

    # A página não deve ter mudado de rota
    expect(page).to have_current_path(monthly_fees_path)
  end
end
