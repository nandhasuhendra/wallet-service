class CreateWallets < ActiveRecord::Migration[8.0]
  def change
    create_table :wallets, id: false do |t|
      t.bigint :id, primary_key: true, null: false
      t.string :name, null: false
      t.boolean :primary, default: false, null: false
      t.decimal :balance, precision: 10, scale: 2, default: 0.0, null: false
      t.references :owner, polymorphic: true, null: false
      t.datetime :deleted_at

      t.timestamps
    end
    
    add_index :wallets, %i[name deleted_at], unique: true
    add_index :wallets, %i[owner_id owner_type deleted_at], unique: true
  end
end
