module Spree
  class StatusMailer < BaseMailer
    add_template_helper(CabinetHelper)

    def status_email(order)
      @order = order
      mail(to: @order.email, from: from_address(@order.store), subject: t('mails.status_email'))
    end
  end
end
