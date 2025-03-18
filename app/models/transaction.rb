class Transaction < ApplicationRecord
  belongs_to :category, class_name: "TransactionCategory", foreign_key: "category_id"
  belongs_to :source, polymorphic: true
  belongs_to :target, polymorphic: true, optional: true
  belongs_to :wallet

  enum :status, { pending: 0, completed: 1, failed: 2 }, default: :pending

  validates :status, :source, :wallet, :category, presence: true
  validate :source_and_target_must_be_different
  validate :transaction_category

  after_commit :publish_transaction

  private

  def source_and_target_must_be_different
    return unless target.blank?

    errors.add(:target, "must be different from source") if source == target
  end

  def transaction_category
    errors.add(:category, "must be a valid transaction category") unless category.valid_transaction?
  end

  def publish_transaction
    ActiveSupport::Notifications.instrument("transactions.#{self.status}", transaction: self)
  end
end
