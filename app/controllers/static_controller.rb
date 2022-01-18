class StaticController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing]

  def landing
    if user_signed_in?
      redirect_to home_path
    end
  end

  def logged_in_landing
  end
end
