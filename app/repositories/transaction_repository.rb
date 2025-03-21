class TransactionRepository
  class << self
    def find_by_wallet_id(wallet_id)
      Transaction.where(wallet_id: wallet_id).order(created_at: :desc)
    end

    def find_by_id_with_lock(id)
      Transaction.lock("FOR UPDATE").find(id)
    end
  end
end
