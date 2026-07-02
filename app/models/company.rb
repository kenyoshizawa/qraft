class Company < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  has_many :clients, dependent: :destroy

  validates :name, presence: true
  validates :postal_code, presence: true, postal_code_format: true
  validates :address, presence: true
  validates :phone, presence: true, phone_format: true
  validates :fax, presence: true, phone_format: true
end
