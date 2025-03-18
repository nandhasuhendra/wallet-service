class Wallet < ApplicationRecord
  DEFAULT_WALLET_NAME = "Main".freeze

  belongs_to :owner, polymorphic: true

  has_many :transactions, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: %i[owner_id owner_type deleted_at] }
  validate :primary_wallet_uniqueness, if: -> { primary? }

  before_validation do
    self.name = name&.strip
  end

  before_save do
    self.name = name&.titleize
  end

  private

  def primary_wallet_uniqueness
    return unless Wallet.where(owner: owner, primary: true).exists?

    errors.add(:primary, "already exists")
  end
end
