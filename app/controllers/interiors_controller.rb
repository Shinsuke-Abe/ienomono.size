# coding: utf-8

class InteriorsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_interior, :only => [:show, :destroy, :edit_tags, :update_tags]

  # GET /interiors
  def index
    @interiors = current_user.interiors
  end

  # GET /interiors/1
  def show(id)
    # do nothing
  end

  # GET /interiors/new
  def new
    @interior = current_user.interiors.build
  end

  # POST /interiors
  def create(interior)
    @interior = current_user.interiors.build(interior)

    if @interior.save
      redirect_to @interior, notice: 'Interior was successfully created.'
    else
      render action: 'new'
    end
  end

  # DELETE /interiors/1
  def destroy(id)
    @interior.destroy

    redirect_to interiors_url
  end

  # GET /interiors/1/edit_tags
  def edit_tags(id)
    render_js_request @interior
  end

  def update_tags(id, interior)
    @interior.category_tags = current_user.create_tagging_list(interior[:joined_tags])

    if @interior.save
      flash[:notice] = "Update tagging was successfully."
      render js: "window.location = '#{interior_path(id)}'"
    else
      render_js_request @interior
    end
  end

  def search_by_tags(search_tags)
    # 入力した検索条件を退避
    @search_tags = search_tags

    selected_tag_ids = CategoryTag.find_tag_id_list(search_tags, current_user)
    @interiors = Interior.search_by_tagging(current_user, selected_tag_ids)
    render action: "index"
  end

  def search_by_memo_text(search_memo)
    # 入力した検索条件を退避
    @search_memo = search_memo

    @interiors = Interior.search_by_memo_text(current_user, search_memo)
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

  def load_interior
    @interior ||= current_user.interiors.find(params[:id])
  end
end
