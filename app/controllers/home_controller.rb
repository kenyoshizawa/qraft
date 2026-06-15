class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def top
    skip_authorization
  end
end
