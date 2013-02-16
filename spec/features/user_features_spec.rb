# encoding: utf-8
require 'spec_helper'

describe 'ユーザ機能' do
  it "未認証場合はログインページにリダイレクトする" do
    not_logined_access interiors_path
    not_logined_access new_interior_path
    not_logined_access edit_interior_path(1)
  end
end

def not_logined_access(url)
  visit url
  current_path.should == new_user_session_path
end