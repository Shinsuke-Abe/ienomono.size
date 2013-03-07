# encoding: utf-8
require 'spec_helper'

describe CategoryTag do
  before do
    @first_user = FactoryGirl.create(:first_user)
  end
  describe "self.enable_tags" do

    it "user_idがnilのレコードを取得可能" do
      expect_tags = FactoryGirl.create_list(:category_tag, 4, user: nil)

      actual_tags = CategoryTag.enable_tags(@first_user)

      expect_to_enable_tags(actual_tags, expect_tags)
    end

    it "user_idが指定されたレコードを取得可能" do
      expect_tags = FactoryGirl.create_list(:category_tag, 2, user: @first_user)

      actual_tags = CategoryTag.enable_tags(@first_user)

      expect_to_enable_tags(actual_tags, expect_tags)
    end

    it "user_idとnilが指定されたレコードを取得可能" do
      second_user = FactoryGirl.create(:second_user)

      expect_tags = FactoryGirl.create_list(:category_tag, 3, user: nil)
      expect_tags += FactoryGirl.create_list(:category_tag, 4, user: @first_user)
      FactoryGirl.create_list(:category_tag, 5, user: second_user)

      actual_tags = CategoryTag.enable_tags(@first_user)

      expect_to_enable_tags(actual_tags, expect_tags)
    end

    it "ユーザの指定がない場合はnilのレコードのみ" do
      expect_tags = FactoryGirl.create_list(:category_tag, 6, user: nil)
      FactoryGirl.create_list(:category_tag, 9, user: @first_user)

      actual_tags = CategoryTag.enable_tags

      expect_to_enable_tags(actual_tags, expect_tags)
    end

    def expect_to_enable_tags(actual_tags, expect_tags)
      actual_tags.size.should == expect_tags.size
      expect_tags.each do |tag|
        actual_tags.should include tag
      end
    end
  end

  describe "self.find_tag" do
    it "ユーザ指定のないレコードにマッチする場合に取得可能" do
      expect_tags = FactoryGirl.create_list(:category_tag, 3, user: nil)

      actual_tag = CategoryTag.find_tag(expect_tags[1].name, @first_user)

      actual_tag.should == expect_tags[1]
    end

    it "ユーザ指定のあるレコードにマッチする場合に取得可能" do
      expect_tags = FactoryGirl.create_list(:category_tag, 5, user: @first_user)

      actual_tag = CategoryTag.find_tag(expect_tags[3].name, @first_user)

      actual_tag.should == expect_tags[3]
    end

    it "他のユーザ指定があるレコードにのみマッチする場合は取得不可能" do
      second_user = FactoryGirl.create(:second_user)
      FactoryGirl.create_list(:category_tag, 2, user: nil)
      FactoryGirl.create_list(:category_tag, 8, user: @first_user)
      expect_tags = FactoryGirl.create_list(:category_tag, 4, user: second_user)

      actual_tag = CategoryTag.find_tag(expect_tags[2].name, @first_user)

      actual_tag.should be_nil
    end

    it "引数のユーザ指定を省略した場合はユーザ指定のないレコードにマッチする" do
      expect_tags = FactoryGirl.create_list(:category_tag, 8, user: nil)

      actual_tag = CategoryTag.find_tag(expect_tags[5].name)

      actual_tag.should == expect_tags[5]
    end
  end

  describe "self.create_tagging_list" do
    it "should description" do
      # TODO
    end
  end

  after do
    FactoryGirl.reload
  end
end
