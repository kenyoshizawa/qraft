FactoryBot.define do
  factory :company do
    name { "株式会社田中建設" }
    postal_code { "1000001" }
    address { "東京都千代田区千代田1-1" }
    phone { "0312345678" }
    fax { "0312345679" }
  end
end
