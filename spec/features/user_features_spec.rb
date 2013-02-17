# encoding: utf-8
require 'spec_helper'

describe 'ユーザ機能' do
  it "未認証場合はログインページにリダイレクトする" do
    not_logined_access interiors_path
    not_logined_access new_interior_path
    not_logined_access edit_interior_path(1)
  end

  it "メールアドレスでログインできる" do
    first_user = FactoryGirl.create(:first_user)

    login_user_action(login: first_user.email, password: first_user.password)
  end

  it "名前でログインできる" do
    second_user = FactoryGirl.create(:second_user)

    login_user_action(login: second_user.user_name, password: second_user.password)
  end

  after do
    FactoryGirl.reload
  end
end

def login_user_action(login_info)
  visit new_user_session_path

  fill_in "user_login", :with => login_info[:login]
  fill_in "user_password", :with => login_info[:password]
  click_button "Sign in"

  current_path.should == root_path
end

def not_logined_access(url)
  visit url
  current_path.should == new_user_session_path
end