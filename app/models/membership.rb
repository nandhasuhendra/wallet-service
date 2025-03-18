# == Schema Information
#
# Table name: memberships
#
#  id         :integer          not null, primary key
#  team_id    :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_memberships_on_team_id  (team_id)
#  index_memberships_on_user_id  (user_id)
#

class Membership < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  before_destroy :cannot_remove_creator

  private

  def cannot_remove_creator
    raise "cannot remove creator" if user == team.creator
  end
end
