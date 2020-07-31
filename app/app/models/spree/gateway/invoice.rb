# rubocop:disable all
module Spree
  class Gateway::Invoice < Gateway
    NAME = 'Invoice'.freeze
    CARD = '4111111111111111'.freeze
    TYPE = 'VISA'.freeze

    attr_accessor :test

    def provider_class
      self.class
    end

    def preferences
      {}
    end

    def method_type
      'invoice'
    end

    def create_profile(payment)
      payment.source.update_attributes(gateway_customer_profile_id: generate_profile_id(true))
    end

    def authorize(money, credit_card, options = {})
      ActiveMerchant::Billing::Response.new(
        true,
        'Invoice Gateway: success',
        {},
        test: true,
        authorization: 'invoice',
        avs_result: { code: 'A' }
      )
    end

    def purchase(money, credit_card, options = {})
      ActiveMerchant::Billing::Response.new(
        true,
        'Invoice Gateway: success',
        {},
        test: true,
        authorization: 'invoice',
        avs_result: { code: 'A' }
      )
    end

    def credit(money, credit_card, response_code, options = {})
      ActiveMerchant::Billing::Response.new(true, 'Invoice Gateway: success', {}, test: true, authorization: 'invoice')
    end

    def capture(authorization, credit_card, gateway_options)
      ActiveMerchant::Billing::Response.new(true, 'Invoice Gateway: success', {}, test: true, authorization: 'invoice')
    end

    def void(response_code, credit_card, options = {})
      ActiveMerchant::Billing::Response.new(true, 'Invoice Gateway: success', {}, test: true, authorization: 'invoice')
    end

    def test?
      true
    end

    def payment_profiles_supported?
      true
    end

    def actions
      %w(capture void credit)
    end

    private

    def generate_profile_id(success)
      record = true
      while record
        random = "INV-#{Array.new(6){rand(6)}.join}"
        record = CreditCard.where(gateway_customer_profile_id: random).first
      end
      random
    end
  end
end
