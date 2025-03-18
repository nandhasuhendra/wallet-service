TransactionCategory::TRANSACTION_TYPE_ID_CONST_MAP.each do |id, name|
  TransactionCategory.find_or_create_by(id: id, name: name)
end

if ENV["CREATE_DUMMY_DATA"] == "true"
  [
    { name: "Alice", email: "alice@email.com", password: "password", password_confirmation: "password" },
    { name: "Bob", email: "bob@email.com", password: "password", password_confirmation: "password" },
    { name: "Charlie", email: "charlie@email.com", password: "password", password_confirmation: "password" },
    { name: "David", email: "david@email.com", password: "password", password_confirmation: "password" },
    { name: "Eve", email: "eve@email.com", password: "password", password_confirmation: "password" }
  ].each do |user|
      User.find_or_create_by!(email: user[:email]) do |u|
        u.name = user[:name]
        u.password = user[:password]
        u.password_confirmation = user[:password_confirmation]
      end
    end

  [
    { name: "Team A", creator: 'Alice', members: %w[Bob] },
    { name: "Team B", creator: 'Charlie', members: %w[David Eve] }
  ].each do |team|
      Team.find_or_create_by!(name: team[:name], creator: User.find_by(name: team[:creator])) do |t|
        t.members = User.where(name: team[:members])
      end
    end
end
