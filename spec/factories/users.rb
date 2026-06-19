FactoryBot.define do
  factory :user do
    sequence(:email) do |n|
      domain = ENV["ALLOWED_DOMAIN"].to_s.split(",").first.presence
      "user#{n}@#{domain}"
    end

    password { "password" }
    role { :general }

    trait :with_profile do
      name { "山田 太郎" }
      name_kana { "ヤマダ タロウ" }
      phone { "09012345678" }
    end

    trait :with_company do
      company
    end

    trait :admin do
      role { :admin }
    end

    trait :general do
      role { :general }
    end

    trait :retired do
      role { :retired }
    end
  end
end
