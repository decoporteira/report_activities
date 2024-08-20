require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe DailyJob, type: :job do
  describe '#perform' do
    it 'enqueues the job correctly' do
      Sidekiq::Testing.fake!

      expect { DailyJob.perform_async(1, 2) }.to change(DailyJob.jobs, :size)
        .by(1)
    end

    it 'executes the job inline' do
      Sidekiq::Testing.inline! { DailyJob.perform_async(1, 2) }

      # Add expectations here for the job execution, if needed
    end
  end
end
