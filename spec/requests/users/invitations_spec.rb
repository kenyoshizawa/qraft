require "rails_helper"

RSpec.describe "Users::Invitations", type: :request do
  describe "GET /users/invitation/new" do
    context "送信者がadminユーザー（company登録済み）の場合" do
      let(:user) { create(:user, :admin, :with_company) }

      it "HTTPステータス200を返すこと" do
        sign_in user
        get new_user_invitation_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "送信者がgeneralユーザー（company登録済み）の場合" do
      let(:user) { create(:user, :general, :with_company) }

      it "トップページにリダイレクトすること" do
        sign_in user
        get new_user_invitation_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "送信者がadminユーザー（company未登録）の場合" do
      let(:user) { create(:user, :admin, company: nil) }

      it "自社情報登録ページにリダイレクトすること" do
        sign_in user
        get new_user_invitation_path
        expect(response).to redirect_to(new_company_path)
      end
    end

    context "送信者がgeneralユーザー（company未登録）の場合" do
      let(:user) { create(:user, :general, company: nil) }

      it "トップページにリダイレクトすること" do
        sign_in user
        get new_user_invitation_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /users/invitation" do
    context "送信者がadminユーザー（company登録済み）の場合" do
      let(:admin_user) { create(:user, :admin, :with_company) }

      context "受信者が有効なメールアドレス（事前にアカウントを作成したadminユーザー）を持つ場合" do
        let(:existing_user) { create(:user, :admin, company: nil) }
        let(:email) { existing_user.email }

        it "招待メールが送信されないこと" do
          sign_in admin_user
          expect {
            post user_invitation_path, params: { user: { email: email } }
          }.not_to change { ActionMailer::Base.deliveries.count }
        end

        it "トップページにリダイレクトすること" do
          sign_in admin_user
          post user_invitation_path, params: { user: { email: email } }
          expect(response).to redirect_to(root_path)
        end
      end

      context "受信者が有効なメールアドレス（事前にアカウントを作成したgeneralユーザー）を持つ場合" do
        let(:existing_user) { create(:user, :general, company: nil) }
        let(:email) { existing_user.email }

        it "招待メールが送信されること" do
          sign_in admin_user
          expect {
            post user_invitation_path, params: { user: { email: email } }
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it "トップページにリダイレクトすること" do
          sign_in admin_user
          post user_invitation_path, params: { user: { email: email } }
          expect(response).to redirect_to(root_path)
        end
      end

      context "受信者が有効なメールアドレス（事前にアカウントを作成していないユーザー）を持つ場合" do
        let(:email) { "newuser@#{ENV['ALLOWED_DOMAIN'].to_s.split(',').first}" }

        it "ユーザーが作成されること" do
          sign_in admin_user
          expect {
            post user_invitation_path, params: { user: { email: email } }
          }.to change(User, :count).by(1)
        end

        it "招待メールが送信されること" do
          sign_in admin_user
          expect {
            post user_invitation_path, params: { user: { email: email } }
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it "トップページにリダイレクトすること" do
          sign_in admin_user
          post user_invitation_path, params: { user: { email: email } }
          expect(response).to redirect_to(root_path)
        end
      end

      context "受信者が無効なメールアドレスの場合" do
        let(:email) { "invalid@otherdomain.com" }

        it "ステータスコード422を返すこと" do
          sign_in admin_user
          post user_invitation_path, params: { user: { email: email } }
          expect(response).to have_http_status(:unprocessable_content)
        end

        it "ユーザーは作成されないこと" do
          sign_in admin_user
          expect {
            post user_invitation_path, params: { user: { email: email } }
          }.not_to change(User, :count)
        end

        it "招待メールが送信されないこと" do
          sign_in admin_user
          expect {
            post user_invitation_path, params: { user: { email: email } }
          }.not_to change { ActionMailer::Base.deliveries.count }
        end
      end

      context "受信者が有効なメールアドレス（自社に所属しているユーザー）を持つ場合" do
        let(:same_company_user) { create(:user, :general, company: admin_user.company) }
        let(:email) { same_company_user.email }

        it "招待メールが送信されないこと" do
          sign_in admin_user
          expect {
            post user_invitation_path, params: { user: { email: email } }
          }.not_to change { ActionMailer::Base.deliveries.count }
        end

        it "トップページにリダイレクトすること" do
          sign_in admin_user
          post user_invitation_path, params: { user: { email: email } }
          expect(response).to redirect_to(root_path)
        end
      end

      context "受信者が有効なメールアドレス（他社に所属しているユーザー）を持つ場合" do
        let(:other_company_user) { create(:user, :general, :with_company) }
        let(:email) { other_company_user.email }

        it "招待メールが送信されないこと" do
          sign_in admin_user
          expect {
            post user_invitation_path, params: { user: { email: email } }
          }.not_to change { ActionMailer::Base.deliveries.count }
        end

        it "トップページにリダイレクトすること" do
          sign_in admin_user
          post user_invitation_path, params: { user: { email: email } }
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context "送信者がgeneralユーザー（company登録済み）の場合" do
      let(:general_user) { create(:user, :general, :with_company) }
      let(:email) { "newuser@#{ENV['ALLOWED_DOMAIN'].to_s.split(',').first}" }

      it "招待メールが送信されないこと" do
        sign_in general_user
        expect {
          post user_invitation_path, params: { user: { email: email } }
        }.not_to change { ActionMailer::Base.deliveries.count }
      end

      it "トップページにリダイレクトすること" do
        sign_in general_user
        post user_invitation_path, params: { user: { email: email } }
        expect(response).to redirect_to(root_path)
      end
    end

    context "送信者がadminユーザー（company未登録）の場合" do
      let(:admin_user) { create(:user, :admin, company: nil) }
      let(:email) { "newuser@#{ENV['ALLOWED_DOMAIN'].to_s.split(',').first}" }

      it "招待メールが送信されないこと" do
        sign_in admin_user
        expect {
          post user_invitation_path, params: { user: { email: email } }
        }.not_to change { ActionMailer::Base.deliveries.count }
      end

      it "自社情報登録ページにリダイレクトすること" do
        sign_in admin_user
        post user_invitation_path, params: { user: { email: email } }
        expect(response).to redirect_to(new_company_path)
      end
    end

    context "送信者がgeneralユーザー（company未登録）の場合" do
      let(:general_user) { create(:user, :general, company: nil) }
      let(:email) { "newuser@#{ENV['ALLOWED_DOMAIN'].to_s.split(',').first}" }

      it "招待メールが送信されないこと" do
        sign_in general_user
        expect {
          post user_invitation_path, params: { user: { email: email } }
        }.not_to change { ActionMailer::Base.deliveries.count }
      end

      it "トップページにリダイレクトすること" do
        sign_in general_user
        post user_invitation_path, params: { user: { email: email } }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /users/invitation/accept" do
    context "トークンが有効な場合" do
      context "受信者が「事前にアカウントを作成していない」adminユーザーの場合" do
        let(:inviter) { create(:user, :admin, :with_company) }
        let(:allowed_domain) { ENV["ALLOWED_DOMAIN"].to_s.split(",").first }

        # Users::InvitationsController#create で実行される invite_resource メソッドを再現する
        # 事前にアカウントを作成していないadminユーザーに、招待メールの送信と招待トークンの生成を行い、
        # 自社情報を紐付けて、invited_by_only を true に設定する
        let(:invited_user) do
          User.invite!({ email: "admin@#{allowed_domain}", role: :admin }, inviter) do |u|
            u.company_id = inviter.company_id
            u.invited_by_only = true
          end
        end

        let(:token) { invited_user.raw_invitation_token }

        it "トップページにリダイレクトすること" do
          get accept_user_invitation_path(invitation_token: token)
          expect(response).to redirect_to(root_path)
        end
      end

      context "受信者が「事前にアカウントを作成していない」generalユーザーの場合" do
        let(:inviter) { create(:user, :admin, :with_company) }
        let(:allowed_domain) { ENV["ALLOWED_DOMAIN"].to_s.split(",").first }

        let(:invited_user) do
          User.invite!({ email: "admin@#{allowed_domain}", role: :general }, inviter) do |u|
            u.company_id = inviter.company_id
            u.invited_by_only = true
          end
        end

        let(:token) { invited_user.raw_invitation_token }

        it "HTTPステータス200を返すこと" do
          get accept_user_invitation_path(invitation_token: token)
          expect(response).to have_http_status(:ok)
        end
      end

      context "受信者が「事前にアカウントを作成している」adminユーザーの場合" do
        let(:inviter) { create(:user, :admin, :with_company) }
        let(:allowed_domain) { ENV["ALLOWED_DOMAIN"].to_s.split(",").first }
        let(:existing_user) { create(:user, :admin, company: nil) }
        let(:token) { existing_user.raw_invitation_token }

        # Users::InvitationsController#create で実行される existing_user.invite!(current_inviter) を再現する
        # 事前にアカウントを作成しているadminユーザーに、招待メールの送信と招待トークンの生成を行い、invited_by_only を false に設定する
        before do
          existing_user.invite!(inviter)
          existing_user.update_column(:invited_by_only, false)
        end

        it "トップページにリダイレクトすること" do
          get accept_user_invitation_path(invitation_token: token)
          expect(response).to redirect_to(root_path)
        end
      end

      context "受信者が「事前にアカウントを作成している」generalユーザーの場合" do
        let(:inviter) { create(:user, :admin, :with_company) }
        let(:allowed_domain) { ENV["ALLOWED_DOMAIN"].to_s.split(",").first }
        let(:existing_user) { create(:user, :general, company: nil) }
        let(:token) { existing_user.raw_invitation_token }

        before do
          existing_user.invite!(inviter)
          existing_user.update_column(:invited_by_only, false)
        end

        it "トップページにリダイレクトすること" do
          get accept_user_invitation_path(invitation_token: token)
          expect(response).to redirect_to(root_path)
        end

        it "自社情報が紐づくこと" do
          get accept_user_invitation_path(invitation_token: token)
          existing_user.reload
          expect(existing_user.company_id).to eq(inviter.company_id)
        end

        it "招待が完了し、トークンが無効化されること" do
          get accept_user_invitation_path(invitation_token: token)
          existing_user.reload
          expect(existing_user.invitation_token).to be_nil
        end
      end
    end

    context "トークンが無効な場合" do
      it "トップページにリダイレクトされること" do
        get accept_user_invitation_path(invitation_token: "invalid_token")
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
