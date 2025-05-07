if ENV["STRIPE_API_KEY"].blank?
  raise "environment: STRIPE_API_KEY not found, please check '.env' and restart."
end

Stripe.api_key = ENV.fetch("STRIPE_API_KEY")
