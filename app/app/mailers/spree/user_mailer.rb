module Spree
  class UserMailer < BaseMailer
    def welcome_email(user)
      @user = user
      @store = Spree::Store.first
      mail(to: @user.email, from: @store.mail_from_address, subject: t('mails.welcome_to_scarpa'))
    end
  end
end
