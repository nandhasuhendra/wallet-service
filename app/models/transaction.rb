class Transaction < ApplicationRecord
  belongs_to :category, class_name: "TransactionCategory", foreign_key: "category_id"
  belongs_to :source, polymorphic: true
  belongs_to :target, polymorphic: true, optional: true
  belongs_to :wallet

  enum :status, { pending: 0, completed: 1, failed: 2 }, default: :pending

  validates :status, :source, :wallet, :category, presence: true

  after_commit :publish_transaction

  private

  def publish_transaction
    ActiveSupport::Notifications.instrument("transactions.#{self.status}", transaction: self)
  end
end
