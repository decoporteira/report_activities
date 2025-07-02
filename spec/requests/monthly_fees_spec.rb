require 'rails_helper'

RSpec.describe "MonthlyFees", type: :request do
  include Devise::Test::IntegrationHelpers
    let(:user) { create(:user) }
  describe "PATCH /monthly_fees/:id/update_paid" do
    let(:student) { create(:student) }
    let(:plan) { create(:plan, :per_class) }
    let(:current_plan) { create(:current_plan, student: student, plan: plan, value_per_hour: 50) }
    let(:monthly_fee) { create(:monthly_fee, student: student, due_date: Date.current) }

    before do
      sign_in user
      allow_any_instance_of(Student).to receive(:current_plan).and_return(current_plan)
    end

    context "when status is 'Paga' and plan is per_class" do
      before do
        headers = { "HTTP_REFERER" => "/" }
        create_list(:private_lesson, 3, current_plan: current_plan, start_time: 1.month.ago.beginning_of_month + 2.days)
        patch '/update_paid', params: { items: { id: monthly_fee.id, status: 'Paga', value: 10 } }, headers: headers

      end

      it "updates the monthly_fee with correct value" do
        monthly_fee.reload
        expect(monthly_fee.status).to eq("Paga")
        expect(monthly_fee.payment_date).to eq(Time.zone.today)
        expect(monthly_fee.value).to eq(150) # 3 aulas * 50
      end
    end

    context "when status is 'Paga' and plan is both" do
      let(:plan) { create(:plan, :both, price: 100) }

      before do
        headers = { "HTTP_REFERER" => "/" }
        create_list(:private_lesson, 2, current_plan: current_plan, start_time: 1.month.ago.beginning_of_month + 5.days)
        patch '/update_paid', params: {
          items: { id: monthly_fee.id, status: "Paga" }
        }, headers: headers
      end

      it "updates with class total + plan price" do
        monthly_fee.reload
        expect(monthly_fee.value).to eq(2 * 50 + 100) # 100 + 100 = 200
      end
    end

    context "when status is not 'Paga'" do
      before do
        headers = { "HTTP_REFERER" => "/" }
        patch '/update_paid', params: {
          items: { id: monthly_fee.id, status: "Atrasada" }
        }, headers: headers
      end

      it "only updates the status" do
        monthly_fee.reload
        expect(monthly_fee.status).to eq("Atrasada")
        expect(monthly_fee.payment_date).to be_nil
      end
    end
  end
end
