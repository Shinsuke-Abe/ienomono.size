# encoding: utf-8
require 'factory_girl'

FactoryGirl.define do
  factory :interior do
    sequence(:name) {|n| "interior name #{n}"}
  end

  factory :first_user, class: User do
    email "user.mail@email.com"
    password "pass1234"
    password_confirmation "pass1234"

    factory :first_user_with_interiors do
      ignore do
        interiors_count 2
      end

      after(:create) do |first_user, evaluator|
        FactoryGirl.create_list(:interior, evaluator.interiors_count, user: first_user)
      end
    end
  end

  factory :second_user, class: User do
    email "user.mail.2@mail.com"
    password "pass9876"
    password_confirmation "pass9876"

    factory :second_user_with_interiors do
      ignore do
        interiors_count 3
      end

      after(:create) do |second_user, evaluator|
        FactoryGirl.create_list(:interior, evaluator.interiors_count, user: second_user)
      end
    end
  end
end