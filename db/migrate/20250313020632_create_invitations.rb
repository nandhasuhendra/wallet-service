class CreateInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :invitations, id: false do |t|
      t.bigint :id, primary_key: true, null: false
      t.string :invitation_token, null: false, index: { unique: true }
      t.datetime :accepted_at, null: true
      t.datetime :expired_at, null: true
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end

    add_index :invitations, %i[team_id sender_id recipient_id], unique: true
  end
end
