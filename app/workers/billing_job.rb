class BillingJob
  include Sidekiq::Job

  def perform(billing_id)
    @billing = Billing.find(billing_id)
    BillingMailer.with(billing: @billing).billing_email.deliver_now
  end
end