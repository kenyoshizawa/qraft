class PagesController < ApplicationController
  def invitation_required
    redirect_to root_path if current_user&.company.present?
  end
end
