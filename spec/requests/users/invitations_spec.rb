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
end
