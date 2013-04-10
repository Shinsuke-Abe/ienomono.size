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
      fill_in "interior_interior_histories_attributes_0_width", with: "25"
      fill_in "interior_interior_histories_attributes_0_height", with: "15"
      fill_in "interior_interior_histories_attributes_0_depth", with: "35"

      click_button "登録する"

      first_user.reload

      expect_to_interior_path(first_user.interiors.first)
    end
  end

  describe "インテリア表示", js: true do
    before do
      @first_user = FactoryGirl.create(:first_user_with_interiors)
      FactoryGirl.create_list(:interior_history, 4, interior: @first_user.interiors.first)

      login_user_action(login: @first_user.user_name, password: @first_user.password)

      expect(page).to have_selector "table tr"
      all("tr")[1].first(:link, "Show").click

      expect_to_interior_path(@first_user.interiors.first)
    end

    it "名前と今使っている物の大きさを表示できる" do
      click_link "Show older history..."

      current_path.should == interior_interior_histories_path(@first_user.interiors.first)

      expect(find("#interior_name")).to have_content @first_user.interiors.first.name

      expect(page).to have_selector "table tr"
      all("tr").length.should == (@first_user.interiors.first.interior_histories.length + 1)
    end

    it "Get new itemリンクを押下すると新しいサイズ入力用のフォームが表示される" do
      click_link "Get new item"

      expect_new_history_form(false)
    end

    it "新しいサイズを入力する" do
      create_new_history_action(width: "25.4", height: "35.4", depth: "65.1")

      sleep 2
      actual_user = User.find(@first_user.id)
      expect_to_interior_path(actual_user.interiors.first)
    end

    it "新しいサイズ入力でエラーになる場合はフォームが再送される" do
      create_new_history_action(width: "", height: "", depth: "")

      expect_to_interior_path(@first_user.interiors.first)

      expect_new_history_form(true, 3)
    end

    it "Edit itemリンクをクリックすると今使っている物の編集用のフォームが表示される" do
      click_link "Edit item"

      latest_history = @first_user.interiors.first.latest_history

      expect_data = {
        start_date: latest_history.start_date,
        width: latest_history.width.to_s,
        height: latest_history.height.to_s,
        depth: latest_history.depth.to_s
      }
      expect_edit_history_form(true, expect_data)
    end

    it "最新の履歴を修正する" do
      latest_history = @first_user.interiors.first.latest_history
      edit_new_history_action(width: "99", height: latest_history.height, depth: latest_history.depth)

      sleep 2
      actual_user = User.find(@first_user.id)
      expect_to_interior_path(actual_user.interiors.first)
    end

    it "最新の履歴編集でエラーになる場合はフォームが再送される" do
      edit_new_history_action(width: "", height: "", depth: "")

      sleep 2
      latest_history = @first_user.interiors.first.latest_history
      expect_data = {
        start_date: latest_history.start_date,
        width: "", height: "", depth: ""
      }
      expect_edit_history_form(true, expect_data, 3)
    end
  end

  def input_and_submit_history_data_action(method, input_history_data)
    case method
    when :create
      get_form_link = "Get new item"
      submit_button = "登録する"
    when :update
      get_form_link = "Edit item"
      submit_button = "更新する"
    end

    click_link get_form_link

    # TODO start_dateのセレクト

    fill_in "interior_history_width", with: input_history_data[:width]
    fill_in "interior_history_height", with: input_history_data[:height]
    fill_in "interior_history_depth", with: input_history_data[:depth]

    click_button submit_button
  end

  def create_new_history_action(new_history_data)
    input_and_submit_history_data_action(:create, new_history_data)
  end

  def edit_new_history_action(update_history_data)
    input_and_submit_history_data_action(:update, update_history_data)
  end

  def expect_new_history_form(has_error, error_field_count = 0)
    within "#history_form" do
      find_field("interior_history_width").value.should == ""
      find_field("interior_history_height").value.should == ""
      find_field("interior_history_depth").value.should == ""

      all(".field_with_errors").length.should == error_field_count if has_error
    end
  end

  def expect_edit_history_form(has_error, expect_data, error_field_count = 0)
    within "#history_form" do
      find_field("interior_history_start_date_1i").value.should == expect_data[:start_date].year.to_s
      find_field("interior_history_start_date_2i").value.should == expect_data[:start_date].month.to_s
      find_field("interior_history_start_date_3i").value.should == expect_data[:start_date].day.to_s

      find_field("interior_history_width").value.should == expect_data[:width]
      find_field("interior_history_height").value.should == expect_data[:height]
      find_field("interior_history_depth").value.should == expect_data[:depth]

      all(".field_with_errors").length.should == error_field_count if has_error
    end
  end

  def expect_to_interior_path(interior)
    current_path.should == interior_path(interior.id)

    expect_history = interior.latest_history

    expect(find("#latest_history_start_date")).to have_content expect_history.start_date.to_s
    expect(find("#latest_history_width")).to have_content expect_history.width
    expect(find("#latest_history_height")).to have_content expect_history.height
    expect(find("#latest_history_depth")).to have_content expect_history.depth
  end

  after do
    FactoryGirl.reload
  end
end