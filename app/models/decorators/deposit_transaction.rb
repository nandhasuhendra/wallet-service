class DepositTransaction < Transaction
  def set_amount(amount)
    self.credit = amount
  end
end
