# encoding: utf-8
class InteriorHistoriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_interior_history, :only => [:edit, :update, :destroy]

  helper_method :current_interior

  def index(interior_id)
    @histories = current_interior.interior_histories
  end

  def new(interior_id)
    render_ajax_form_request history_form_parameter()
  end

  def create(interior_id, interior_history)
    @interior_history = current_interior.interior_histories.build(interior_history)

    if @interior_history.save
      render_persistance_is_successfully("Interior history", "created", interior_id)
    else
      render_ajax_form_request history_form_parameter(@interior_history)
    end
  end

  def edit(interior_id, id)
    render_ajax_form_request history_form_parameter(@interior_history)
  end

  def update(interior_id, id, interior_history)
    if @interior_history.update_attributes(interior_history)
      render_persistance_is_successfully("Interior history", "updated", interior_id)
    else
      render_ajax_form_request history_form_parameter(@interior_history)
    end
  end

  def destroy(interior_id, id)
    @interior_history.destroy

    redirect_to interior_interior_histories_path(interior_id)
  end

  private
  def current_interior
    @current_interior ||= current_user.interiors.find(params[:interior_id])
  end

  def load_interior_history
    @interior_history ||= current_interior.interior_histories.find(params[:id])
  end

  def history_form_parameter(history = nil)
    {partial: 'form', locals: {interior_history: history}}
  end
end
