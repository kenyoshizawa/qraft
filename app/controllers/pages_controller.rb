class PagesController < ApplicationController
  skip_before_action :require_company!, only: %i[ invitation_required ]

  def invitation_required
    redirect_to root_path if current_user&.company.present?
  end
end
