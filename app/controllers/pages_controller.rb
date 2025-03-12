class PagesController < ApplicationController
  allow_unauthenticated_access only: %i[ home ]
  layout "login"
  def home
    # No need to initialize @login_form here
  end
end
