# == Schema Information
#
# Table name: transaction_categories
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TransactionCategory < ApplicationRecord
  TRANSACTION_TYPE_ID_CONST_MAP = {
    1 => "Transfer",
    2 => "Withdrawal",
    3 => "Deposit"
  }

  has_many :transactions
  validates :name, presence: true, uniqueness: true
end
