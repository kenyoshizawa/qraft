class Users::InvitationsController < Devise::InvitationsController
  after_action :verify_authorized, only: %i[ new create ]
  before_action :require_admin!, only: %i[ new create ]
  before_action :reject_company_user!, only: %i[ create ]

  skip_before_action :authenticate_user!, only: %i[ edit update ]
  skip_before_action :require_no_authentication, only: %i[ edit update ]
  before_action :require_general!, only: %i[ edit update ]

  before_action :validate_email!, only: :create

  def new
    authorize User
    super
  end

  def create
    authorize User
    existing_user = User.find_by(email: invite_params[:email])

    if existing_user
      # 事前にアカウント作成している場合 ⇨ そのユーザーに招待メールを送信する
      existing_user.invite!(current_inviter)
      redirect_to root_path, notice: "#{existing_user.email} に招待メールを送信しました。"
    else
      # 事前にアカウントを作成していない場合 ⇨ 新規ユーザーを作成して、そのユーザーに招待メールを送信する
      super
    end
  end

  def edit
    existing_user = User.find_by_invitation_token(params[:invitation_token], true)

    if existing_user.nil?
      redirect_to root_path, alert: "招待リンクが無効または期限切れです。"
      return
    end

    sign_out(current_user) if user_signed_in?

    if existing_user.invited_by_only?
      # アカウントを作成していない場合：
      # invite_resource メソッドを実行し、パスワード入力画面を表示
      super
    else
      # 事前にアカウント作成している場合：
      # invitation を直接更新し、ログイン
      # 不要なバリデーションやコールバックを避けるため update_columns を使用
      existing_user.update_columns(
        company_id: existing_user.invited_by.company_id,
        invitation_accepted_at: Time.current,
        invitation_token: nil,
        invited_by_only: false
      )
      sign_in(existing_user)
      redirect_to root_path, notice: "自社情報が紐づけられました。"
    end
  end

  protected

  def invite_resource
    resource_class.invite!(invite_params, current_inviter) do |invitable|
      invitable.company_id = current_inviter.company_id
      invitable.invited_by_only = true
    end
  end

  private

  def invite_params
    params.require(:user).permit(:email)
  end

  def require_admin!
    redirect_to root_path, alert: "権限がありません" unless current_user.admin?
  end

  def require_general!
    user = User.find_by_invitation_token(params[:invitation_token], false)

    if user&.admin?
      redirect_to root_path, alert: "管理者ユーザーは招待メールを受け取れません。"
    end
  end

  def reject_company_user!
    user = User.find_by(email: invite_params[:email])

    if user&.company_id.present?
      redirect_to root_path, alert: "既に会社に所属しているユーザーです。"
    end
  end

  def validate_email_for_invitation
    user = User.new(email: invite_params[:email])
    validator = AllowedDomainValidator.new(attributes: [ :email ])
    validator.validate_each(user, :email, invite_params[:email])
    user
  end

  def validate_email!
    self.resource = validate_email_for_invitation

    return unless resource.errors[:email].any?

    render :new, status: :unprocessable_entity
  end
end
