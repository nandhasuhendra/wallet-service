class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions, id: false do |t|
      t.bigint :id, primary_key: true, null: false
      t.string :description, null: false
      t.integer :status, null: false, default: 0
      t.decimal :credit, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :debit, precision: 10, scale: 2, default: 0.0, null: false
      t.string :type, null: false
      t.references :creator, null: false, polymorphic: true
      t.references :source, null: false, foreign_key: { to_table: :wallets }
      t.references :target, null: true, foreign_key: { to_table: :wallets }

      t.timestamps
    end

    add_index :transactions, %i[type creator_id creator_type], unique: true
    add_index :transactions, %i[type source_id status], unique: true
    add_index :transactions, %i[type source_id target_id status], unique: true
  end
end
