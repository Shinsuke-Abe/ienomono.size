# encoding: utf-8
require 'spec_helper'

describe "インテリア管理機能" do
  describe "インテリア登録" do
    it "名前と今使っている物の大きさを登録できる" do
      first_user = FactoryGirl.create(:first_user)

      login_user_action(login: first_user.email, password: first_user.password)

      click_link "New Interior"

      current_path.should == new_interior_path

      fill_in "interior_name", with: "インテリア"
      fill_in "interior_interior_history_width", with: "25"
      fill_in "interior_interior_history_height", with: "15"
      fill_in "interior_interior_history_depth", with: "35"

      click_button "登録する"

      first_user.reload

      current_path.should == interior_path(first_user.interiors.first.id)

      expect_history = first_user.interiors.first.latest_history

      expect(find("#latest_history_start_date")).to have_content Date.today.to_s
      expect(find("#latest_history_width")).to have_content expect_history.width
      expect(find("#latest_history_height")).to have_content expect_history.height
      expect(find("#latest_history_depth")).to have_content expect_history.depth
    end
  end

  describe "インテリア表示" do
    it "名前と今使っている物の大きさを表示できる" do
      first_user = FactoryGirl.create(:first_user_with_interiors)
      FactoryGirl.create_list(:interior_history, 4, interior: first_user.interiors.first)

      login_user_action(login: first_user.user_name, password: first_user.password)

      expect(page).to have_selector "table tr"
      all("tr")[1].first(:link, "Show").click

      current_path.should == interior_path(first_user.interiors.first.id)

      expect_history = first_user.interiors.first.latest_history
      expect(find("#latest_history_start_date")).to have_content expect_history.start_date.to_s
      expect(find("#latest_history_width")).to have_content expect_history.width
      expect(find("#latest_history_height")).to have_content expect_history.height
      expect(find("#latest_history_depth")).to have_content expect_history.depth

      click_link "Show older history..."

      current_path.should == interior_interior_histories_path(first_user.interiors.first)

      expect(find("#interior_name")).to have_content first_user.interiors.first.name

      # expect(page).to have_selector "table tr"
      # all("tr").length.should == (first.interiors.first.interior_histories.length)
    end
  end

  after do
    FactoryGirl.reload
  end
end