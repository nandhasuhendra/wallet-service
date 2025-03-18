class WalletRepository
  def self.owner_wallets(owner)
    Wallet.includes(:owner).where(owner: owner).order(created_at: :asc)
  end

  def self.create_default_wallet(owner)
    Wallet.create!(owner: owner, name: Wallet::DEFAULT_WALLET_NAME, balance: 0.0, primary: true)
  end

  def self.create_wallet(owner, name, balance)
    wallet = wallet = Wallet.new(name: name, owner: owner, balance: balance)
    wallet.save
  end

  def self.find_by_owner(owner)
    Wallet.find_by(owner: owner)
  end

  def self.find_by_id_and_owner(wallet_id, owner)
    Wallet.find_by(id: wallet_id, owner: owner)
  end
end
