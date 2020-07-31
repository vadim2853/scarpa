class NewUserSubscriber
  include Sidekiq::Worker

  def perform(user_id)
    user = Spree::User.find(user_id)

    Gibbon::Request
      .lists(Rails.application.secrets.mailchimp_list_id)
      .members(Digest::MD5.hexdigest(user.email))
      .upsert(user_params(user))
  end

  private

  def user_params(user)
    {
      body: {
        email_address: user.email,
        status: 'subscribed',
        merge_fields:
          {
            FNAME: user.first_name,
            LNAME: user.last_name
          }
      }
    }
  end
end
