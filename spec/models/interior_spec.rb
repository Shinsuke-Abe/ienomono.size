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
    it "タグの設定がない場合はjoined_tags_string項目が空になる" do
      new_interior = Interior.new

      expect(new_interior.joined_tags_string.blank?).to be_true
    end

    it "タグの指定があるオブジェクトを取得した場合はjoined_tags_string項目が取得できる" do
      tag_list = FactoryGirl.create_list(:category_tag, 2, user: nil)
      tag_list += FactoryGirl.create_list(:category_tag, 3, user: @first_user)
      @target_interior.category_tags = tag_list
      # @target_interior.save

      actual_interior = Interior.find(@target_interior.id)

      actual_interior.joined_tags_string.should == tag_list.map{|tag| tag.name}.join(",")
    end
  end

  describe ".search_by_tagging" do
    it "1個のタグで検索する" do
      add_tag_list_to_interior!(@target_interior, 3, @first_user)

      actual_interiors = Interior.search_by_tagging(
        @first_user,
        [@target_interior.category_tags.first.id])
      actual_interiors.first.id.should == @target_interior.id
    end

    it "それぞれ一つのインテリアにマッチする複数のタグで検索する" do
      add_tag_list_to_interior!(@target_interior, 1, @first_user)
      add_tag_list_to_interior!(@first_user.interiors[1], 2, @first_user)

      actual_interiors = Interior.search_by_tagging(
        @first_user,
        [@target_interior.category_tags.first.id,
         @first_user.interiors[1].category_tags.first.id])
      actual_interiors.length.should == 2
    end

    it "一つのインテリアにマッチする複数のタグで検索する" do
      add_tag_list_to_interior!(@target_interior, 5, @first_user)

      actual_interiors = Interior.search_by_tagging(@first_user, [2,3])

      actual_interiors.length.should == 1
    end

    it "タグ付けされていない物は検索されない" do
      actual_interiors = Interior.search_by_tagging(@first_user, [1,2])

      actual_interiors.should be_empty
    end

    def add_tag_list_to_interior!(interior, count, user)
      tag_list = FactoryGirl.create_list(:category_tag, count, user: user)
      interior.category_tags = tag_list
    end
  end

  describe ".search_by_memo_text" do
    it "履歴のメモに検索文字が含まれているインテリアを取得可能" do
      FactoryGirl.create_list(:interior_history, 4, interior: @target_interior)
      FactoryGirl.create_list(:interior_history_for_search, 1, interior: @target_interior)

      actual_interiors = Interior.search_by_memo_text(@first_user, "机")
      actual_interiors.length.should == 1
      actual_interiors.first.id.should == @target_interior.id
    end

    it "履歴がないものは検索されない" do
      actual_interiors = Interior.search_by_memo_text(@first_user, "not found")
      actual_interiors.should be_empty
    end

    it "マッチしない文字列は検索されない" do
      FactoryGirl.create_list(:interior_history, 4, interior: @target_interior)

      actual_interiors = Interior.search_by_memo_text(@first_user, "not found")
      actual_interiors.should be_empty
    end
  end

  describe ".list_users_have" do
    before do
      FactoryGirl.create(:second_user_with_interiors)
    end

    it "ユーザを指定しない場合は全レコード検索" do
      actual_list = Interior.list_users_have()

      expect(actual_list.length).to eq Interior.find(:all).length
    end

    it "ユーザを指定した場合は指定したユーザで検索" do
      actual_list = Interior.list_users_have(@first_user)

      expect(actual_list.length).to eq Interior.where(["user_id = ?", @first_user.id]).length
    end
  end

  after do
    FactoryGirl.reload
  end
end
