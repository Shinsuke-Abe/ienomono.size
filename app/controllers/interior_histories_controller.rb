# encoding: utf-8
class InteriorHistoriesController < ApplicationController
  before_filter :authenticate_user!

  def index(interior_id)
    @current_interior = current_user.interiors.find(interior_id)
    @histories = current_user.interiors.find(interior_id).interior_histories
  end

  def new(interior_id)
    @interior_history = current_user.interiors.find(interior_id).interior_histories.build

    html = render_to_string partial: 'form', collection: [@interior_history]

    render json: {html: html}
  end
end
