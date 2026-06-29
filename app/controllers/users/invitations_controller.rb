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
      # 事前にアカウントを作成していない場合 ⇨ invite_resource で新規ユーザーを作成して、そのユーザーに招待メールを送信する
      super
    end
  end

  def edit
    # 招待トークンからユーザーを取得
    invited_user = find_invited_user

    if invited_user.nil?
      redirect_to root_path, alert: "招待リンクが無効または期限切れです。"
      return
    end

    sign_out(current_user) if user_signed_in?

    if invited_user.invited_by_only?
      # アカウントを作成していない場合：
      # Devise Invitable の通常フローでパスワード入力画面を表示
      super
    else
      # 事前にアカウント作成している場合：
      # 作成済みユーザーに自社情報を紐づけてログイン
      accept_invitation_for_existing_user(invited_user)
    end
  end

  protected

  # 新規Userを作成し、招待トークンを発行して招待メールを送信する
  # 作成時に招待者の company_id を紐づけ、invited_by_only を true に設定する
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
    # 有効・無効に関係なく、招待リンクに対応するユーザーを探す
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

  def reject_admin_user!
    user = User.find_by(email: invite_params[:email])

    if user&.admin?
      redirect_to root_path, alert: "管理者ユーザーには招待メールを送信できません。"
    end
  end

  def validate_email!
    # 招待フォームでバリデーションエラーを表示するため、検証用の resource にエラーを保持する
    self.resource = User.new(email: invite_params[:email])
    validator = AllowedDomainValidator.new(attributes: [ :email ])
    validator.validate_each(resource, :email, resource.email)

    return unless resource.errors[:email].any?

    render :new, status: :unprocessable_entity
  end

  def find_invited_user
    # 有効な招待リンクをもつユーザーを探す
    User.find_by_invitation_token(params[:invitation_token], true)
  end

  def accept_invitation_for_existing_user(user)
    # バリデーションやコールバックを避けるため update_columns を使用
    user.update_columns(
      company_id: user.invited_by.company_id,
      invitation_accepted_at: Time.current,
      invitation_token: nil,
      invited_by_only: false
    )

    sign_in(user)
    redirect_to root_path, notice: "自社情報が紐づけられました。"
  end
end
