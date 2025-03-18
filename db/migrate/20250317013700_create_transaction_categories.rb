class CreateTransactionCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :transaction_categories, id: false do |t|
      t.bigint :id, primary_key: true, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
