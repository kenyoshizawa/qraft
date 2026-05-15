class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :name_kana, :phone ])
  end

  def after_sign_in_path_for(resource)
    if resource.company.present?
      root_path
    elsif resource.admin?
      flash[:alert] = "自社情報を登録してください"
      new_company_path
    else
      flash[:alert] = "管理者ユーザーから招待メールを受け取ってください"
      invitation_required_path
    end
  end

  private

  def company_registered!
    return unless user_signed_in?
    return if current_user.company.present?

    if current_user.admin?
      redirect_to new_company_path, alert: "自社情報を登録してください"
    else
      redirect_to invitation_required_path, alert: "管理者ユーザーから招待メールを受け取ってください"
    end
  end
end
