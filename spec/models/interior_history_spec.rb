# encoding: utf-8
require 'spec_helper'

describe InteriorHistory do
  describe "before_save" do
    it "入力値にstart_dateがない場合は今日の日付をセットする" do
      actual = new_history_save(
        width: 35.1,
        height: 25.1,
        depth: 17.1)

      actual.start_date.should == Date.today
    end

    it "入力値にstart_dateがある場合はセットされた日付が優先される" do
      actual = new_history_save(
        start_date: Date.yesterday,
        width: 15)

      actual.start_date.should == (Date.yesterday)
    end

    def new_history_save(input_data)
      actual = InteriorHistory.new(input_data)
      actual.save
      actual
    end
  end

  describe ".invalid?" do
    before do
      @input_data = {
        width: 35.1,
        height: 25.1,
        depth: 17.1
      }
    end

    it "width,height,depthの全てがnilの場合" do
      expect_to_invalid_true(nil)
    end

    it "widthが数値以外の場合" do
      @input_data[:width] = "sf"

      expect_to_invalid_true(@input_data)
    end

    it "heightが数値以外の場合" do
      @input_data[:height] = "dc"

      expect_to_invalid_true(@input_data)
    end

    it "depthが数値以外の場合" do
      @input_data[:depth] = "ab"

      expect_to_invalid_true(@input_data)
    end

    def expect_to_invalid_true(input_data)
      actual = InteriorHistory.new(input_data)
      expect(actual.invalid?).to be_true
    end
  end
end
