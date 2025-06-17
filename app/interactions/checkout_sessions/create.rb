module CheckoutSessions
  class Create < ActiveInteraction::Base
    object :user
    string :price
    integer :quantity, default: 1
    string :success_url, default: "https://example.com/success"
    string :cancel_url, default: nil
    string :mode, default: "subscription" # payment or subscription
    string :customer_email, default: nil

    validate :validate_stripe_state!

    def execute
      data = Stripe::Checkout::Session.create(payload)
      session = StripeCheckoutSession.create!(
        user_id: user.id,
        session_uid: data.id,
        amount_subtotal: data.amount_subtotal,
        amount_total: data.amount_total,
        created: data.created,
        expires_at: data.expires_at,
        url: data.url,
        status: data.status,
        price_uid: price,
      )
      StripeCheckoutSessionSerializer.new(session).serializable_hash.to_json
    rescue Stripe::StripeError => e
      raise ApiError::StripeRequestError.new(e.message)
    rescue ActiveRecord::RecordInvalid, ArgumentError => e
      raise ApiError::ActiveRecordError.new(e.message)
    end

    private

    # 校验
    # 	1.	检查是否有未支付的订单
    # 	2.	检查是否已订阅
    # 	3.	检查 price 对应的本地记录是否存在
    # 	4. 检查该价格配置的 credits 是否合理
    def validate_stripe_state!
      raise ApiError::OpenStripeCheckoutSessionExistsError if user.stripe_checkout_sessions.open.exists?
      raise ApiError::ActiveStripeSubscriptionExistsError if user.stripe_subscriptions.active.exists?

      stripe_price = StripePrice.find_by(price_uid: price)
      if stripe_price.nil? || stripe_price.credit_quota <= 0
        raise ApiError::InvalidStripePriceError
      end
    end

    def payload
      req = { line_items: [{ price:, quantity: }], success_url:, mode:, metadata: { user_id: user.id } }
      req[:customer_creation] = "always" if mode == "payment"
      req[:customer_email] = customer_email if customer_email
      req
    end
  end
end
