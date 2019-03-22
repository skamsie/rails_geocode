FactoryBot.define do
  factory :user do
    name { "Billy" }
    email { "#{name.gsub(' ', '_')}@example.com".downcase }
    password { "123123" }
  end
end
