# encoding: utf-8
require 'spec_helper'

describe InteriorsController do
  describe 'GET index' do
    it "ログインユーザの一覧が取得できる" do
      expected = FactoryGirl.create(:first_user_with_interiors)
      FactoryGirl.create(:second_user_with_interiors)

      sign_in :user, expected
      get :index

      expect(assigns[:interiors].length).to eq(expected.interiors.length)
    end
  end
end
