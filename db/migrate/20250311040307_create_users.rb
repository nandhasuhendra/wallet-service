class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.bigint :id, primary_key: true, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :users, %I[email deleted_at], unique: true
  end
end
