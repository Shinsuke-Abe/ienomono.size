# encoding: utf-8
class InteriorHistoriesController < ApplicationController
  before_filter :authenticate_user!

  helper_method :current_interior

  def index(interior_id)
    @histories = current_interior.interior_histories
  end

  def new(interior_id)
    html = render_to_string partial: 'form', locals: {interior_history: @interior_history}
    render json: {html: html}
  end

  def create(interior_id, interior_history)
    @interior_history = current_interior.interior_histories.build(interior_history)

    if @interior_history.save
      flash[:notice] = 'Interior history was successfully created.'
      render js: "window.location = '#{interior_path(interior_id)}'"
    else
      html = render_to_string partial: 'form', locals: {interior_history: @interior_history}
      render json: {html: html}
    end
  end

  def edit(interior_id, id)
    @interior_history = current_interior.interior_histories.find(id)
    html = render_to_string partial: 'form', locals: {interior_history: @interior_history}
    render json: {html: html}
  end

  private
  def current_interior
    @current_interior ||= current_user.interiors.find(params[:interior_id])
  end
end
