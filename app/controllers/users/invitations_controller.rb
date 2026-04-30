class Users::InvitationsController < Devise::InvitationsController
  before_action :company_registered!
end
