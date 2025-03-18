module TransactionHelper
  extend ActiveSupport::Concern

  included do
    has_many :source_transactions, class_name: "Transaction", as: :source, dependent: :destroy
    has_many :target_transactions, class_name: "Transaction", as: :target, dependent: :destroy
  end

  def transactions
    sql_query = "(source_type = :type AND source_id = :id) OR (target_type = :type AND target_id = :id)"
    Transaction.where(sql_query, type: self.class.name, id: self.id)
  end
end
