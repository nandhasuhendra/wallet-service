class Transaction < ApplicationRecord
  belongs_to :category, class_name: "TransactionCategory", foreign_key: "category_id"

  enum :status, { pending: 0, completed: 1, failed: 2 }, _default: :pending

  validates :status, :source, :wallet, :category, presence: true
  validate :source_and_target_must_be_different

  after_commit :publish_transaction

  private

  def source_and_target_must_be_different
    return unless target.blank?

    errors.add(:target, "must be different from source") if source == target
  end

  def publish_transaction
    if pending?
      ActiveSupport::Notifications.instrument("transactions.pending", transaction: self)
    elsif completed?
      ActiveSupport::Notifications.instrument("transactions.completed", transaction: self)
    elsif failed?
      ActiveSupport::Notifications.instrument("transactions.failed", transaction: self)
    end
  end
end
