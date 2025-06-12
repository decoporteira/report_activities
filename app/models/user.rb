class User < ApplicationRecord
  has_one :teacher, dependent: :nullify
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable
  enum role: { default: 0, teacher: 1, accounting: 2, admin: 3 }
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :default
  end

  def authorized_user?
    admin? || accounting?
  end
end
