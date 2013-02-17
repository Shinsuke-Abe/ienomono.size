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

  after do
    FactoryGirl.reload
  end
end
