json.data do
  json.partial! "invite", collection: @invitations, as: :invite
end
