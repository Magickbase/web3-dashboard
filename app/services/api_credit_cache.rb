module ApiCreditCache
  API_CREDIT_KEY_PREFIX = "api_credit_cost".freeze

  def self.key_for(route)
    "#{API_CREDIT_KEY_PREFIX}:#{route}"
  end

  def self.write(route, credit_cost)
    $redis.set(key_for(route), credit_cost)
  end

  def self.read(route)
    $redis.get(key_for(route)).to_i
  end

  def self.delete(route)
    $redis.del(key_for(route))
  end
end
