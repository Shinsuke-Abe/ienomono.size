# coding: utf-8

class InteriorsController < ApplicationController
  before_filter :authenticate_user!

  # GET /interiors
  def index
    @interiors = current_user.interiors
  end

  # GET /interiors/1
  def show(id)
    @interior = current_user.interiors.find(id)
  end

  # GET /interiors/new
  def new
    @interior = current_user.interiors.build
  end

  # POST /interiors
  def create(interior)
    @interior = current_user.build_interior_with_history(interior)

    if @interior.save
      redirect_to @interior, notice: 'Interior was successfully created.'
    else
      render action: 'new'
    end
  end

  # DELETE /interiors/1
  def destroy(id)
    @interior = current_user.interiors.find(id)
    @interior.destroy

    redirect_to interiors_url
  end

  # GET /interiors/1/edit_tags
  def edit_tags(id)
    render_js_request current_user.interiors.find(id)
  end

  def update_tags(id, interior)
    current_interior = current_user.interiors.find(id)
    current_interior.category_tags = current_user.create_tagging_list(interior[:joined_tags].split(","))

    if current_interior.save
      flash[:notice] = "Update tagging was successfully."
      render js: "window.location = '#{interior_path(id)}'"
    else
      render_js_request current_interior
    end
  end

  def search_by_tags
    # TODO 入力されたタグ名から存在するタグIDのリスト取得
  end

  def search_by_memo_text(search_memo)
    @search_memo = search_memo
    @interiors = Interior.find_by_memo_text(current_user, search_memo)
    render action: "index"
  end


  autocomplete :category_tag, :name

  # オートコンプリートの結果にフィルターをかけるためにオーバーライド
  def get_autocomplete_items(parameters)
    items = super(parameters)
    items = items.enable_tags(current_user)
  end

  private
  def render_js_request(interior)
    html = render_to_string partial: 'tagging_form', locals: {interior: interior}
    render json: {html: html}
  end
end
