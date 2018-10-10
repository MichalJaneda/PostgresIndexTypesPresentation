FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    insurance_number { rand(36**64).to_s(36) }
    post_code { Faker::Address.postcode }

    registered_from { Faker::Internet.ip_v4_address }
    current_location { "POINT(#{rand(-180.0..180.0)} #{rand(-180.0..180.0)})" }

    about { Faker::Lorem.paragraph(5, false, 5) }
  end
end
