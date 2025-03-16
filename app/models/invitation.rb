# == Schema Information
#
# Table name: invitations
#
#  id               :integer          not null, primary key
#  invitation_token :string           not null
#  email            :string           not null
#  accepted_at      :datetime
#  expired_at       :datetime
#  team_id          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_invitations_on_email_and_team_id  (email,team_id) UNIQUE
#  index_invitations_on_invitation_token   (invitation_token) UNIQUE
#  index_invitations_on_team_id            (team_id)
#

class Invitation < ApplicationRecord
  belongs_to :team

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :invitation_token, presence: true, uniqueness: true

  before_validation :generate_invitation_token, on: :create
  befor_create :set_expired_at

  def accept!(user)
    raise 'invitation already accepted' if accepted_at.present?
    raise 'invitation expired' if expired_at < time.current

    ActiveRecord::Base.transaction do
      team.members << user
      update!(accepted_at: Time.current)
    end
  end

  private

  def generate_invitation_token
    self.invitation_token = SecureRandom.hex(16)
  end

  def set_expired_at
    self.expired_at = 1.week.from_now
  end
end
