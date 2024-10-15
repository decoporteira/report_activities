require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe BillingStudentsEvenJob, type: :job do
  before do
    Sidekiq::Testing.fake! # Ensure no actual Sidekiq job is performed
    Sidekiq::Queues['default'].clear # Clear the Sidekiq queue before each test
    ActionMailer::Base.deliveries.clear # Clear email deliveries before each test
  end

  describe '#perform' do
    context 'when today is a Saturday' do
      it 'reschedules the job to the next Monday' do
        travel_to Time.zone.local(2024, 9, 7, 10, 0, 0) do # Saturday
          expected_date = Time.zone.local(2024, 9, 9).beginning_of_day
          BillingStudentsEvenJob.perform_at(expected_date)

          # Check that the job was enqueued and rescheduled to Monday
          expect(Sidekiq::Queues['default'].size).to eq(1)
          job = Sidekiq::Queues['default'].first

          # Convert expected_date to float timestamp to match Sidekiq's format
          expect(job['at']).to eq(expected_date.to_f)
        end
      end
    end

    context 'when today is a Sunday' do
      it 'reschedules the job to the next Monday' do
        travel_to Time.zone.local(2024, 9, 8, 10, 0, 0) do # Sunday
          expected_date = Time.zone.local(2024, 9, 9).beginning_of_day
          BillingStudentsEvenJob.perform_at(expected_date)

          # Check that the job was enqueued and rescheduled to Monday
          expect(Sidekiq::Queues['default'].size).to eq(1)
          job = Sidekiq::Queues['default'].first

          # Convert expected_date to float timestamp to match Sidekiq's format
          expect(job['at']).to eq(expected_date.to_f)
        end
      end
    end
  end
end
