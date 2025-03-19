class Transaction < ApplicationRecord
  belongs_to :creator, polymorphic: true
  belongs_to :source, class_name: "Wallet", foreign_key: "source_id"
  belongs_to :target, class_name: "Wallet", foreign_key: "target_id", optional: true

  enum :status, { pending: 0, completed: 1, failed: 2 }, default: :pending

  validates :creator, :status, presence: true

  after_commit :publish_transaction

  def fail!
    update!(status: :failed)
  end

  def set_amount(amount)
    raise NotImplementedError, "You must implement #{self.class}##{__method__}"
  end

  private

  def publish_transaction
    ActiveSupport::Notifications.instrument("transactions.#{self.status}", transaction: self)
  end
end
