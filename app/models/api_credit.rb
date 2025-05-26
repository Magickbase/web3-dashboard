class ApiCredit < ApplicationRecord
end

# == Schema Information
#
# Table name: api_credits
#
#  id          :bigint           not null, primary key
#  credit_cost :integer          default(0)
#  description :text
#  path        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_api_credits_on_path  (path) UNIQUE
#
