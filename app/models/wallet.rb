class Wallet < ApplicationRecord
  belongs_to :owner, polymorphic: true

  validates :name, presence: true, uniqueness: { scope: %i[owner_id deleted_at] }
  validate :primary_wallet_uniqueness, if: -> { primary? }

  before_validation do
    self.name = name&.strip
  end

  before_save do
    self.name = name&.titleize
  end

  private

  def primary_wallet_uniqueness
    return unless owner.wallets.where(primary: true).exists?

    errors.add(:primary, "already exists")
  end
end
