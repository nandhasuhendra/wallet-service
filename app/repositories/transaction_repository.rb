class TransactionRepository
  class << self
    def find_by_wallet_id(wallet_id)
      Transaction.where(wallet_id: wallet_id).order(created_at: :desc)
    end
  end
end
