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
end
