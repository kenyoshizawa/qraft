require "rails_helper"

RSpec.describe "After sign in", type: :request do
  describe "POST /users/sign_in" do
    context "company登録済みの場合" do
      context "adminユーザーの場合" do
        it "root_pathにリダイレクトされること" do
          admin = create(:user, :admin, :with_company)
          post user_session_path, params: { user: { email: admin.email, password: admin.password } }
          expect(response).to redirect_to(root_path)
        end
      end

      context "generalユーザーの場合" do
        it "root_pathにリダイレクトされること" do
          general = create(:user, :general, :with_company)
          post user_session_path, params: { user: { email: general.email, password: general.password } }
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context "company未登録の場合" do
      context "adminユーザーの場合" do
        it "new_company_pathにリダイレクトされること" do
          admin = create(:user, :admin, company: nil)
          post user_session_path, params: { user: { email: admin.email, password: admin.password } }
          expect(response).to redirect_to(new_company_path)
        end

        it "指定したフラッシュメッセージが表示されること" do
          admin = create(:user, :admin, company: nil)
          post user_session_path, params: { user: { email: admin.email, password: admin.password } }
          expect(flash[:alert]).to eq("自社情報を登録してください。")
        end
      end

      context "generalユーザーの場合" do
        it "invitation_required_pathにリダイレクトされること" do
          general = create(:user, :general, company: nil)
          post user_session_path, params: { user: { email: general.email, password: general.password } }
          expect(response).to redirect_to(invitation_required_path)
        end

        it "指定したフラッシュメッセージが表示されること" do
          general = create(:user, :general, company: nil)
          post user_session_path, params: { user: { email: general.email, password: general.password } }
          expect(flash[:alert]).to eq("管理者ユーザーから招待メールを受け取ってください。")
        end
      end
    end
  end
end
