json.data do
  json.partial! "wallet", collection: @wallets, as: :wallet
end
