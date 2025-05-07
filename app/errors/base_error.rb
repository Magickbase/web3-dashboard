class BaseError < StandardError
  include ActiveModel::Serialization
  extend ActiveModel::Naming

  attr_accessor :code, :status, :message, :detail, :request_id

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
end