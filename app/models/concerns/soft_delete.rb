module SoftDelete
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where(deleted_at: nil) }
    scope :deleted, -> { where.not(deleted_at: nil) }

    def soft_delete
      update(deleted_at: Time.current)
    end

    def restore
      update(deleted_at: nil)
    end

    def deleted?
      deleted_at.present?
    end
  end
end
