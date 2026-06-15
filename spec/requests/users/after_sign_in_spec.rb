require "rails_helper"

RSpec.describe "After sign in", type: :request do
  describe "POST /users/sign_in" do
    context "adminユーザーの場合" do
      context "company登録済みの場合" do
        it "root_pathにリダイレクトされること" do
          admin = create(:user, :admin, :with_company)
          post user_session_path, params: { user: { email: admin.email, password: admin.password } }
          expect(response).to redirect_to(root_path)
        end
      end

      context "company未登録の場合" do
        it "new_company_pathにリダイレクトされること" do
          admin = create(:user, :admin, company: nil)
          post user_session_path, params: { user: { email: admin.email, password: admin.password } }
          expect(response).to redirect_to(new_company_path)
        end
      end
    end

    context "generalユーザーの場合" do
      context "company登録済みの場合" do
        it "root_pathにリダイレクトされること" do
          general = create(:user, :general, :with_company)
          post user_session_path, params: { user: { email: general.email, password: general.password } }
          expect(response).to redirect_to(root_path)
        end
      end

      context "company未登録の場合" do
        it "invitation_required_pathにリダイレクトされること" do
          general = create(:user, :general, company: nil)
          post user_session_path, params: { user: { email: general.email, password: general.password } }
          expect(response).to redirect_to(invitation_required_path)
        end
      end
    end
  end
end
