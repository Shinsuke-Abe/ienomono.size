# encoding: utf-8
require 'spec_helper'

describe Interior do
  describe ".latest_history" do
    before do
      first_user = FactoryGirl.create(:first_user_with_interiors)
      @target_interior = first_user.interiors.first
    end
    it "最も最近の履歴を取得できる" do
      histories = FactoryGirl.create_list(:interior_history, 3, interior: @target_interior)

      expected_history = histories.max{|a, b| a.start_date <=> b.start_date}

      @target_interior.latest_history.id.should == expected_history.id
    end

    it "履歴がないときはnilを返す" do
      @target_interior.latest_history.should be_nil
    end
  end

  after do
    FactoryGirl.reload
  end
end
