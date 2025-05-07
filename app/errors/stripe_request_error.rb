class StripeRequestError < BaseError
  def initialize(message)
    super(code: 1000, status: 400, message:)
  end
end
