class PagesController < ApplicationController
  def invitation_required
    authorize :page
  end
end
