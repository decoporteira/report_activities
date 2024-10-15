require 'rails_helper'

RSpec.describe BillingStudentsEvenJob, type: :job do
  before do
    allow(BillingMailer).to receive_message_chain(:with, :billing_email).and_return(double(deliver_now: true))
  end

  it 'sends an email to each student when they have no financial responsible' do
    student = create(:student, email: 'student@example.com', status: :registered)
    student_two = create(:student, email: 'student_two@example.com', status: :registered)
    student_three = create(:student, email: 'student_two@example.com', status: :unregistered)

    BillingStudentsEvenJob.new.perform

    expect(BillingMailer).not_to have_received(:with).with(recipient: student)
    expect(BillingMailer).to have_received(:with).with(recipient: student_two)
    expect(BillingMailer).not_to have_received(:with).with(recipient: student_three)

    expect(BillingMailer.with(recipient: student).billing_email).to have_received(:deliver_now).once
    expect(BillingMailer.with(recipient: student_two).billing_email).to have_received(:deliver_now).once
    expect(BillingMailer.with(recipient: student_three).billing_email).to have_received(:deliver_now).once
  end
end
