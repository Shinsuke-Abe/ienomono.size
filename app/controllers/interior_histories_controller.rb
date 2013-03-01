# encoding: utf-8
class InteriorHistoriesController < ApplicationController
  before_filter :authenticate_user!

  def index(interior_id)
    @histories = current_interior(interior_id).interior_histories
  end

  def new(interior_id)
    html = render_to_string partial: 'form'
    render json: {html: html}
  end

  def create(interior_id, interior_history)
    @interior_history = current_interior(interior_id).interior_histories.build(interior_history)

    if @interior_history.save
      flash[:notice] = 'Interior history was successfully created.'
      render js: "window.location = '#{interior_path(interior_id)}'"
    else
      html = render_to_string partial: 'form', collection: [@interior_history]
      render json: {html: html}
    end
  end

  private
  def current_interior(interior_id)
    @current_interior ||= current_user.interiors.find(interior_id)
  end
end
