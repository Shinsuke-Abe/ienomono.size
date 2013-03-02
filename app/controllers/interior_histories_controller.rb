# encoding: utf-8
class InteriorHistoriesController < ApplicationController
  before_filter :authenticate_user!

  helper_method :current_interior

  def index(interior_id)
    @histories = current_interior.interior_histories
  end

  def new(interior_id)
    render_js_request()
  end

  def create(interior_id, interior_history)
    @interior_history = current_interior.interior_histories.build(interior_history)

    if @interior_history.save
      success_persistence_response("created", interior_id)
    else
      render_js_request(@interior_history)
    end
  end

  def edit(interior_id, id)
    @interior_history = load_interior_history(id)
    render_js_request(@interior_history)
  end

  def update(interior_id, id, interior_history)
    @interior_history = load_interior_history(id)

    if @interior_history.update_attributes(interior_history)
      success_persistence_response("updated", interior_id)
    else
      render_js_request(@interior_history)
    end
  end

  private
  def current_interior
    @current_interior ||= current_user.interiors.find(params[:interior_id])
  end

  def load_interior_history(id)
    @interior_history = current_interior.interior_histories.find(id)
  end

  def success_persistence_response(method, interior_id)
    flash[:notice] = "Interior history was successfully #{method}."
    render js: "window.location = '#{interior_path(interior_id)}'"
  end

  def render_js_request(interior_history = nil)
    html = render_to_string partial: 'form', locals: {interior_history: interior_history}
    render json: {html: html}
  end
end
