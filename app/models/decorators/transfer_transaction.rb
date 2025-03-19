class TransferTransaction < Transaction
  validate :source_and_target_must_be_different

  def set_amount(amount)
    self.debit = amount
    self.credit = amount
  end

  private

  def source_and_target_must_be_different
    return unless target.blank?

    errors.add(:target, "must be different from source") if source == target
  end
end
