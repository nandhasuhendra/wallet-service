class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions, id: false do |t|
      t.bigint :id, primary_key: true, null: false
      t.string :description, null: false
      t.integer :status, null: false, default: 0
      t.decimal :credit, precision: 10, scale: 2, default: 0.0, null: false
      t.decimal :debit, precision: 10, scale: 2, default: 0.0, null: false
      t.references :source, polymorphic: true, null: false
      t.references :wallet, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: { to_table: :transaction_categories }
      
      t.timestamps
    end

    add_index :transactions, %i[wallet_id status], unique: true
    add_index :transactions, %i[source_id source_type wallet_id status], unique: true
  end
end
