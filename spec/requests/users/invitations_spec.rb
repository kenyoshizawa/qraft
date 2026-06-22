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
end
