class Client < ApplicationRecord
  belongs_to :company

  validates :name, presence: true, length: { maximum: 50 }
  validates :name_kana, presence: true, length: { maximum: 50 }, company_name_kana_format: true
  validates :postal_code, presence: true, postal_code_format: true
  validates :address, presence: true
  validates :phone, presence: true, phone_format: true
  validates :fax, presence: true, phone_format: true, allow_blank: true
end
