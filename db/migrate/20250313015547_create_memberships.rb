class CreateMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :memberships, id: false do |t|
      t.bigint :id, primary_key: true, null: false
      t.references :team, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
