class CreditsService
  class InsufficientCreditsError < StandardError; end

  def initialize(user)
    @user = user
  end

  # 每月订阅时重置 credits
  def reset_credits!(quota)
    @user.update!(total_credits: quota, remaining_credits: quota)
  end

  # 扣减 credits（API 调用等）
  def deduct!(amount)
    if @user.remaining_credits >= amount
      @user.update!(remaining_credits: @user.remaining_credits - amount)
    else
      raise InsufficientCreditsError
    end
  end
end
