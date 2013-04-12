class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout

  private
  def layout
    if is_a?(Devise::SessionsController) or
       is_a?(Devise::RegistrationsController)
      "single"
    else
      "application"
    end
  end

  def render_ajax_form_request(render_parameters)
    html = render_to_string render_parameters
    render json: {html: html}
  end

  def render_persistance_is_successfully(model_name, method, interior_id)
    flash[:notice] = "#{model_name} was successfully #{method}."
    render js: "window.location = '#{interior_path(interior_id)}'"
  end
end
