FactoryBot.define do
  factory :client do
    name { "株式会社伊藤工務店" }
    name_kana { "イトウコウムテン" }
    postal_code { "1500001" }
    address { "東京都渋谷区神宮前1-1-1" }
    phone { "0398765432" }
    fax { "0398765433" }
    company
  end
end
