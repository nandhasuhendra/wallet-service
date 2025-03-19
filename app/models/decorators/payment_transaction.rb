class PaymentTransaction < Transaction
  def set_amount(amount)
    self.debit = amount
  end
end
