# encoding: utf-8
require 'factory_girl'

FactoryGirl.define do
  factory :interior_history do
    sequence(:start_date) {|n| Date.today - n}
    sequence(:height) {|n| 1.5 + n}
    sequence(:width) {|n| 1.2 + n}
  end

  factory :interior_history_for_search, class: InteriorHistory do
    sequence(:start_date) {|n| Date.today - n}
    height 35.5
    width 15.5
    memo_text "初めて買った机\n大事な物"
  end

  factory :interior do
    sequence(:name) {|n| "interior name #{n}"}
  end

  factory :first_user, class: User do
    email "user.mail@email.com"
    password "pass1234"
    password_confirmation "pass1234"
    user_name "first_user"

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
    user_name "second_user"

    factory :second_user_with_interiors do
      ignore do
        interiors_count 3
      end

      after(:create) do |second_user, evaluator|
        FactoryGirl.create_list(:interior, evaluator.interiors_count, user: second_user)
      end
    end
  end

  factory :nemo, class: User do
    email "nemo@mail.com"
    password "nemo9999"
    password_confirmation "nemo9999"
  end

  factory :category_tag do
    sequence(:name) {|n| "tag name #{n}"}
  end

  factory :search_tag, class: CategoryTag do
    sequence(:name) {|n| "search_tag #{n}"}
  end
end