# encoding: utf-8
require 'spec_helper'

describe Interior do
  before do
    @first_user = FactoryGirl.create(:first_user_with_interiors)
    @target_interior = @first_user.interiors.first
  end

  describe ".latest_history" do
    it "最も最近の履歴を取得できる" do
      histories = FactoryGirl.create_list(:interior_history, 3, interior: @target_interior)

      expected_history = histories.max{|a, b| a.start_date <=> b.start_date}

      @target_interior.latest_history.id.should == expected_history.id
    end

    it "履歴がないときはnilを返す" do
      @target_interior.latest_history.should be_nil
    end
  end

  describe ".tags_string" do
    it "タグの設定がない場合はbrankがtrueになる" do
      expect(@target_interior.tags_string.blank?).to be_true
    end
  end

  describe "初期化" do
    it "タグの設定がない場合はjoined_tags項目が空になる" do
      new_interior = Interior.new

      expect(new_interior.joined_tags.blank?).to be_true
    end

    it "タグの指定があるオブジェクトを取得した場合はjoined_tags項目が取得できる" do
      tag_list = FactoryGirl.create_list(:category_tag, 2, user: nil)
      tag_list += FactoryGirl.create_list(:category_tag, 3, user: @first_user)
      @target_interior.category_tags = tag_list
      # @target_interior.save

      actual_interior = Interior.find(@target_interior.id)

      actual_interior.joined_tags.should == tag_list.map{|tag| tag.name}.join(",")
    end
  end

  describe "全文検索" do
    it "インテリアの名前を検索できる" do
      actual_interiors = Interior.search('"interior name 1"', load: true)

      actual_interiors.length.should == 1
      actual_interiors.first.id.should == @target_interior.id
      actual_interiors.first.name.should == @target_interior.name
    end

    it "ヒットしない条件ではリストのサイズが0になる" do
      actual_interiors = Interior.search('"not found name"', load: true)

      actual_interiors.length.should == 0
    end

    it "複数ユーザにわたるインデックスを検索できる" do
      second_user = FactoryGirl.create(:second_user_with_interiors)

      expect_size = @first_user.interiors.size + second_user.interiors.size

      Interior.search("interior name").size.should == expect_size
    end

    it "ユーザIDでフィルターをかける" do
      FactoryGirl.create(:second_user_with_interiors)

      mask_user_id = @first_user.id

      actual_interiors = Interior.search do
        query {string '"interior name"'}

        filter :terms, user_id: [mask_user_id]
      end

      actual_interiors.size.should == @first_user.interiors.size
    end

    it "関連づけているタグも検索可能" do
      tag_list = FactoryGirl.create_list(:category_tag, 2, user: nil)
      tag_list += FactoryGirl.create_list(:category_tag, 3, user: @first_user)
      @target_interior.category_tags = tag_list
      @target_interior.save

      mask_user_id = @first_user.id

      actual_interiors = Interior.search load: true do
        query {string '"tag"'}

        filter :terms, user_id: [mask_user_id]
      end

      actual_interiors.size.should == 1
      actual_interiors.first.id.should == @target_interior.id
    end
  end

  after do
    FactoryGirl.reload
  end
end
