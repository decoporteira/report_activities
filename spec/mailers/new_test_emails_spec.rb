require 'rails_helper'

RSpec.describe BillingJob, type: :job do
  before do
    # Stub `deliver_now` to track calls but prevent sending actual emails
    allow(BillingMailer).to receive_message_chain(:with, :billing_email).and_return(double(deliver_now: true))
  end

  it 'sends an email to each student when they have no financial responsible' do
    student = create(:student, email: 'student@example.com', status: :registered)
    student_two = create(:student, email: 'student_two@example.com', status: :registered)
    student_three = create(:student, email: 'student_two@example.com', status: :registered)

    # Run the BillingJob
    BillingJob.new.perform

    # Ensure `BillingMailer.with(recipient: student)` was called
    expect(BillingMailer).to have_received(:with).with(recipient: student).once
    expect(BillingMailer).to have_received(:with).with(recipient: student_two).once
    expect(BillingMailer).to have_received(:with).with(recipient: student_three).once

    # Ensure `billing_email.deliver_now` was called once for each student
    expect(BillingMailer.with(recipient: student).billing_email).to have_received(:deliver_now).twice
    expect(BillingMailer.with(recipient: student_two).billing_email).to have_received(:deliver_now).twice
    expect(BillingMailer.with(recipient: student_three).billing_email).to have_received(:deliver_now).twice
  end
end
