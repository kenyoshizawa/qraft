class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :company_registered!, if: :user_signed_in?

  def top
  end
end
