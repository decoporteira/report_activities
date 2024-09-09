require 'rails_helper'

RSpec.describe BillingJob, type: :job do
  before do
    # Clear email deliveries and stub logger before each test
    ActionMailer::Base.deliveries.clear
    allow(Rails.logger).to receive(:info)
  end

  describe '#perform' do
    context 'when today is a Saturday' do
      it 'reschedules the job to the next Monday and does not send any emails' do
        travel_to Time.zone.local(2024, 9, 7, 10, 0, 0) do # Saturday

          # Perform the job
          BillingJob.new.perform

          # Check that no emails were sent
          expect(ActionMailer::Base.deliveries).to be_empty

          # Check the log output
          expect(Rails.logger).to have_received(:info).with(/Reagendado para 09\/09\/2024/)
        end
      end
    end

    context 'when today is a Sunday' do
      it 'reschedules the job to the next Monday and does not send any emails' do
        travel_to Time.zone.local(2024, 9, 8, 10, 0, 0) do # Sunday

          # Perform the job
          BillingJob.new.perform

          # Check that no emails were sent
          expect(ActionMailer::Base.deliveries).to be_empty

          # Check the log output
          expect(Rails.logger).to have_received(:info).with(/Reagendado para 09\/09\/2024/)
        end
      end
    end

    context 'when today is a weekday and there are students without financial responsibles' do
      it 'sends emails to students without financial responsibles' do
        travel_to Time.zone.local(2024, 9, 10, 10, 0, 0) do # Example weekday
          student = create(:student, email: 'student@example.com', status: :registered)
  
          BillingJob.new.perform

          # Check that an email was sent to the student
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          email = ActionMailer::Base.deliveries.last
          expect(email.to).to include('student@example.com')
          expect(email.subject).to eq('Your Billing Information') # Adjust based on your actual subject
        end
      end
    end

    context 'when there are financial responsibles' do
      it 'sends emails to financial responsibles' do
        travel_to Time.zone.local(2024, 9, 10, 10, 0, 0) do # Example weekday
          student = create(:student, email: 'student@example.com', status: :registered)
          financial_responsible = create(:financial_responsible, email: 'responsible@example.com')
          responsible = Responsible.create(financial_responsible_id: financial_responsible.id, student_id: student.id)
          puts responsible
          # Perform the job
          BillingJob.new.perform

          # Check that an email was sent to the financial responsible
          expect(ActionMailer::Base.deliveries.count).to eq(1)
          email = ActionMailer::Base.deliveries.last
          expect(email.to).to include('responsible@example.com')
          expect(email.subject).to eq('Your Billing Information') # Adjust based on your actual subject
        end
      end
    end
  end
end
