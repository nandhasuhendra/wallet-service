json.data do
  json.partial! "member", collection: @memberships, as: :member
end
