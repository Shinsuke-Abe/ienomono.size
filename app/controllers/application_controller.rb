class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :layout

  private
  def layout
    is_a?(Devise::SessionsController) ? "single" : "application"
  end
end
