class TransferTransaction < Transaction
  validate :source_and_target_must_be_different

  private

  def source_and_target_must_be_different
    return unless target.blank?

    errors.add(:target, "must be different from source") if source == target
  end
end
