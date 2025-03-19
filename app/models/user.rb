# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email_and_deleted_at  (email,deleted_at) UNIQUE
#

class User < ApplicationRecord
  has_secure_password

  has_many :memberships, dependent: :destroy
  has_many :teams, through: :memberships
  has_many :created_teams, class_name: "Team", foreign_key: :creator_id
  has_many :wallets, as: :owner, dependent: :destroy
  has_many :transactions, as: :creator, dependent: :destroy

  validates :name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false, scope: :deleted_at }

  after_commit :publish_creation_event, on: :create

  private

  def publish_creation_event
    ActiveSupport::Notifications.instrument("users.creation", user: self)
  end
end
