FactoryGirl.define do
  factory :post do
    sequence(:title) {|n| "#{Faker::Company.bs} #{n}" }
    body { Faker::Hipster.paragraph }
  end
end
