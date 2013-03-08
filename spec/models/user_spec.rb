# encoding: utf-8
require 'spec_helper'

describe User do
  describe ".find_for_database_authentication" do
    it "login条件にメールアドレスを指定して取得できる" do
      first_user = FactoryGirl.create(:first_user)

      actual = User.find_for_database_authentication(login: first_user.email)

      actual.id.should == first_user.id
    end

    it "login条件に名前を指定して取得できる" do
      second_user = FactoryGirl.create(:second_user)

      actual = User.find_for_database_authentication(login: second_user.user_name)

      actual.id.should == second_user.id
    end

    it "login条件にメールアドレスも名前もマッチしない場合は取得できない" do
      first_user = FactoryGirl.create(:first_user)

      actual = User.find_for_database_authentication(login: "no_user")

      actual.should be_nil
    end
  end

  describe ".welcome_name" do
    it "名前がある場合は名前優先" do
      first_user = FactoryGirl.create(:first_user)

      first_user.welcome_name.should == first_user.user_name
    end

    it "名前がない場合はメールアドレスが返る" do
      nemo = FactoryGirl.create(:nemo)

      nemo.welcome_name.should == nemo.email
    end
  end

  describe ".build_interior_with_history" do
    before do
      @first_user = FactoryGirl.create(:first_user)
    end

    it "履歴を一緒に持つインテリアモデルのインスタンスを生成する" do
      expect_to_has_history(
        name: "テストインテリア",
        interior_history: {
          width: 25,
          height: 15,
          depth: 35
        })
    end

    it "文字列で入力された履歴を一緒に持つインテリアモデルのインスタンスを生成する" do
      expect_to_has_history(
        name: "テストインテリア",
        interior_history: {
          width: "25",
          height: "15",
          depth: "35"
        })
    end

    def expect_to_has_history(interior_data)
      interior = @first_user.build_interior_with_history(interior_data)

      interior.name.should == interior_data[:name]
      interior.interior_histories.size.should == 1
      interior.interior_histories.first.start_date.should == Date.today
      interior.interior_histories.first.width.should == interior_data[:interior_history][:width].to_f
      interior.interior_histories.first.height.should == interior_data[:interior_history][:height].to_f
      interior.interior_histories.first.depth.should == interior_data[:interior_history][:depth].to_f
    end

    it "履歴がない場合は履歴オブジェクトを持たないインテリアモデルを生成する" do
      expect_to_has_no_history(name: "テストインテリア")
    end

    it "履歴のデータが全て入力されていない場合は履歴オブジェクトを持たないインテリアモデルを生成する" do
      expect_to_has_no_history(
        name: "テストインテリア",
        interior_history: {
          width: nil,
          height: nil,
          depth: nil
        })
    end

    it "履歴のデータが全て空文字の場合は履歴オブジェクトを持たないインテリアモデルを生成する" do
      expect_to_has_no_history(
        name: "テストインテリア",
        interior_history: {
          width: "",
          height: "",
          depth: ""
        })
    end

    def expect_to_has_no_history(interior_data)
      interior = @first_user.build_interior_with_history(interior_data)

      interior.name.should == interior_data[:name]
      expect(interior.interior_histories.blank?).to be_true
    end
  end

  describe ".create_tagging_list" do
    before do
      @first_user = FactoryGirl.create(:first_user)
    end

    it "存在しないタグを指定した場合は新しいレコードを返す" do
      actual_list = @first_user.create_tagging_list(["タグ1"])

      expect_to_create_tagging_list(actual_list, "タグ1", @first_user.id)
    end

    it "存在するタグを指定した場合はそのレコードを返す" do
      user_category_tag = FactoryGirl.create_list(:category_tag, 4, user: @first_user)

      actual_list = @first_user.create_tagging_list([user_category_tag[2].name])

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
