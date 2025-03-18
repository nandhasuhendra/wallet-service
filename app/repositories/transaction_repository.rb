class TransactionRepository
  class << self
    def find_by_wallet_id(wallet_id)
      Transaction.where(wallet_id: wallet_id).order(created_at: :desc)
    end

    def find_by_id_and_lock(id)
      Transaction.where(id: id).lock("FOR UPDATE").last
    end
  end
end
