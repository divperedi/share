class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }
  layout "login"

  def new
  end

  def create
    if user = User.authenticate_by(params[:login], params[:password])
      start_new_session_for user
      redirect_to posts_path
    else
      redirect_to new_session_path, alert: "Try another email address, username, or password."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path
  end
end
