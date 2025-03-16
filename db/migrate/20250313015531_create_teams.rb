class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams, id: false do |t|
      t.bigint :id, primary_key: true, null: false
      t.string :name, null: false
      t.datetime :deleted_at, null: true
      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :teams, %i[name deleted_at], unique: true
  end
end
