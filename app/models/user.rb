class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { general: 0, admin: 1, retired: 2 }

  VALID_NAME_REGEX = /\A[^\p{blank}]+ [^\p{blank}]+\z/
  VALID_NAME_KANA_REGEX = /\A[ァ-ヶー]+(?: [ァ-ヶー]+)*\z/

  validates :email, uniqueness: { case_sensitive: false }, allowed_domain: true

  validates :name,
    length: { maximum: 20 },
    format: { with: VALID_NAME_REGEX, message: "は氏名の間に半角スペースを入れてください" },
    allow_blank: true
  validates :name_kana,
    length: { maximum: 20 },
    format: { with: VALID_NAME_REGEX, message: "は氏名の間に半角スペースを入れてください" },
    allow_blank: true
  validates :name_kana,
    format: { with: VALID_NAME_KANA_REGEX, message: "は全角カタカナで入力してください" },
    allow_blank: true

  def active_for_authentication?
    super && !retired?
  end

  def inactive_message
    retired? ? :retired_account : super
  end
end
