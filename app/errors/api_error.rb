class ApiError < StandardError
  include ActiveModel::Serialization
  extend ActiveModel::Naming

  attr_accessor :code, :status, :message, :request_id

  def initialize(code:, status:, message:, request_id: nil)
    @code = code
    @status = status
    @message = message
    @request_id = request_id
    super
  end

  def to_s
    "code: #{code}, status: #{status}, message: #{message}, request_id: #{request_id}"
  end

  class StripeRequestError < ApiError
    def initialize(message)
      super(code: 1001, status: 400, message:)
    end
  end

  class ActiveRecordError < ApiError
    def initialize(message)
      super(code: 1002, status: 400, message:)
    end
  end

  class OpenStripeCheckoutSessionExistsError < ApiError
    def initialize
      super(code: 1003, status: 400, message: "a pending checkout session already exists")
    end
  end

  class ActiveStripeSubscriptionExistsError < ApiError
    def initialize
      super(code: 1004, status: 400, message: "an active subscription already exists")
    end
  end

  class PageOverflowError < ApiError
    def initialize
      super(code: 1005, status: 400, message: "page overflow")
    end
  end

  class StripeCheckoutSessionNotFoundError < ApiError
    def initialize(session_uid)
      super(code: 1006, status: 404, message: "stripe checkout session #{session_uid} not found")
    end
  end
end
