class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { general: 0, admin: 1, retired: 2 }

  validates :email, presence: true, uniqueness: { case_insensitive: true }, allowed_domain: true, allow_blank: true

  def active_for_authentication?
    super && !retired?
  end

  def inactive_message
    retired? ? :retired_account : super
  end
end
