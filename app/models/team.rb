# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  deleted_at :datetime
#  creator_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_teams_on_creator_id           (creator_id)
#  index_teams_on_name_and_deleted_at  (name,deleted_at) UNIQUE
#

class Team < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: :creator_id

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, class_name: 'User', source: :user

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :deleted_at }
  validate :cannot_invite_deleted_user, on: :update

  private

  def cannot_invite_deleted_user
    errors.add(:members, 'cannot invite deleted user') if members.any?(&:deleted_at)
  end
end
