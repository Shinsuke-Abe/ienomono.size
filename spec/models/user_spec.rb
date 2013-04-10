# encoding: utf-8
require 'spec_helper'

describe User do
  before do
    @first_user = FactoryGirl.create(:first_user)
  end

  describe ".find_for_database_authentication" do
    it "login条件にメールアドレスを指定して取得できる" do
      actual = User.find_for_database_authentication(login: @first_user.email)

      actual.id.should == @first_user.id
    end

    it "login条件に名前を指定して取得できる" do
      second_user = FactoryGirl.create(:second_user)

      actual = User.find_for_database_authentication(login: second_user.user_name)

      actual.id.should == second_user.id
    end

    it "login条件にメールアドレスも名前もマッチしない場合は取得できない" do
      actual = User.find_for_database_authentication(login: "no_user")

      actual.should be_nil
    end
  end

  describe ".welcome_name" do
    it "名前がある場合は名前優先" do
      @first_user.welcome_name.should == @first_user.user_name
    end

    it "名前がない場合はメールアドレスが返る" do
      nemo = FactoryGirl.create(:nemo)

      nemo.welcome_name.should == nemo.email
    end
  end

  describe ".create_tagging_list" do
    it "存在しないタグを指定した場合は新しいレコードを返す" do
      actual_list = @first_user.create_tagging_list("タグ1")

      expect_to_create_tagging_list(actual_list, "タグ1", @first_user.id)
    end

    it "存在するタグを指定した場合はそのレコードを返す" do
      user_category_tag = FactoryGirl.create_list(:category_tag, 4, user: @first_user)

      actual_list = @first_user.create_tagging_list(user_category_tag[2].name)

      expect_to_create_tagging_list(actual_list, user_category_tag[2].name, @first_user.id)
    end

    def expect_to_create_tagging_list(actual_list, expect_name, expect_user_id)
      actual_list.should have_exactly(1).items
      actual_list[0].name.should == expect_name
      actual_list[0].user_id.should == expect_user_id
    end
  end

  after do
    FactoryGirl.reload
  end
end
