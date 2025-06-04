class UserSerializer
  include JSONAPI::Serializer

  set_id :subject
  attributes :total_credits, :remaining_credits
  attribute :stripe_customers do |user|
    user.stripe_customers.map do |customer|
      {
        id: customer.customer_uid,
        email: customer.email,
        created: customer.created,
      }
    end
  end
end
