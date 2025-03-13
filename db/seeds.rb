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
