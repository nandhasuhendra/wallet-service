ActiveSupport::Notifications.subscribe("users.creation") do |_name, _start, _finish, _id, payload|
  ::Wallets::CreatePrimaryService.new(owner: payload[:user]).call
end

ActiveSupport::Notifications.subscribe("teams.creation") do |_name, _start, _finish, _id, payload|
  ::Wallets::CreatePrimaryService.new(owner: payload[:team]).call
end
