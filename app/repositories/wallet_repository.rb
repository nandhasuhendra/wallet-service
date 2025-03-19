class WalletRepository
  class << self
    def owner_wallets(owner)
      Wallet.includes(:owner).where(owner: owner).order(created_at: :asc)
    end

    def create_default_wallet(owner)
      Wallet.create!(owner: owner, name: Wallet::DEFAULT_WALLET_NAME, balance: 0.0, primary: true)
    end

    def create_wallet(owner, name, balance)
      wallet = wallet = Wallet.new(name: name, owner: owner, balance: balance)
      wallet.save
    end

    def find_by_owner(owner)
      Wallet.find_by(owner: owner)
    end

    def find_by_id_and_owner(wallet_id, owner)
      Wallet.find_by(id: wallet_id, owner: owner)
    end

    def find_by_id_and_lock(wallet_id, owner)
      Wallet.where(id: wallet_id, owner: owner).lock("FOR UPDATE").last
    end

    def find_by_number(wallet_number)
      Wallet.find_by(number: wallet_number)
    end

    def find_by_number_and_lock(wallet_number)
      Wallet.lock("FOR UPDATE").find_by(number: wallet_number)
    end

    def adjust_balance!(wallet_id, amount)
      wallet = Wallet.find(wallet_id)
      wallet.with_lock! do
        new_balance = balance + amount
        raise ActiveRecord::Rollback, "Insufficient funds" if new_balance < 0

        wallet.update!(balance: new_balance)
      end
    end
  end
end
