class StaticController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing]

  def landing
  end

  def logged_in_landing
  end
end
