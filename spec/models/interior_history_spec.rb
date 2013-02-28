# encoding: utf-8
require 'spec_helper'

describe InteriorHistory do
  describe "before_save" do
    it "入力値にstart_dateがない場合は今日の日付をセットする" do
      input_data = {
        width: 35.1,
        height: 25.1,
        depth: 17.1
      }

      actual = InteriorHistory.new(input_data)
      actual.save

      actual.start_date.should == Date.today
    end

    it "入力値にstart_dateがある場合はセットされた日付が優先される" do
      input_data = {
        start_date: Date.yesterday,
        width: 15
      }

      actual = InteriorHistory.new(input_data)
      actual.save

      actual.start_date.should == (Date.yesterday)
    end
  end
end
