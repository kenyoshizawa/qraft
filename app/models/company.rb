class Company < ApplicationRecord
  has_many :users, dependent: :restrict_with_error

  VALID_POSTAL_CODE_REGEX = /\A\d{7}\z/

  validates :name, presence: true
  validates :postal_code, presence: true,
    format: {
      with: VALID_POSTAL_CODE_REGEX,
      message: "は半角数字（ハイフンなし）で入力してください"
    }
  validates :address, presence: true
  validates :phone, presence: true, phone: { possible: true, countries: :jp }, phone_format: true
  validates :fax, presence: true, phone: { possible: true, countries: :jp }, phone_format: true
end
