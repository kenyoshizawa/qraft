class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company, optional: true

  enum role: { general: 0, admin: 1, retired: 2 }

  validates :email,
    uniqueness: { case_sensitive: false }, allowed_domain: true
  validates :name,
    length: { maximum: 20 }, name_format: true, allow_blank: true
  validates :name_kana,
    length: { maximum: 20 }, name_kana_format: true, allow_blank: true
  validates :phone,
    phone_format: true, allow_blank: true

  # Deviseのログイン可否を判定するメソッドをオーバーライド
  # retiredユーザーはログインを拒否される
  def active_for_authentication?
    super && !retired?
  end

  # ログインが拒否された場合、表示されるメッセージのキーを返すメソッドをオーバーライド
  # retiredユーザーの場合は:retired_accountを返し、それ以外はDeviseのデフォルトメッセージを返す
  def inactive_message
    retired? ? :retired_account : super
  end
end
