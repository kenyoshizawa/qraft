require "rails_helper"

RSpec.describe "Companies", type: :request do
  describe "GET /companies/:id" do
    context "ログイン済みの場合" do
      context "company登録済みの場合" do
        context "adminユーザーの場合" do
          let(:user) { create(:user, :admin, :with_company) }

          it "トップページにリダイレクトすること" do
            sign_in user
            get company_path(user.company)
            expect(response).to redirect_to(root_path)
          end
        end

        context "generalユーザーの場合" do
          let(:user) { create(:user, :general, :with_company) }

          it "HTTPステータス200を返すこと" do
            sign_in user
            get company_path(user.company)
            expect(response).to have_http_status(:ok)
          end

          it "自社情報が取得できること" do
            sign_in user
            get company_path(user.company)
            expect(response.body).to include(user.company.name)
          end
        end
      end

      context "company未登録の場合" do
        let(:other_user) { create(:user, :admin, :with_company) }

        context "adminユーザーの場合" do
          let(:user) { create(:user, :admin, company: nil) }

          it "自社情報登録ページにリダイレクトすること" do
            sign_in user
            get company_path(other_user.company)
            expect(response).to redirect_to(new_company_path)
          end
        end

        context "generalユーザーの場合" do
          let(:user) { create(:user, :general, company: nil) }

          it "招待待ちページにリダイレクトすること" do
            sign_in user
            get company_path(other_user.company)
            expect(response).to redirect_to(invitation_required_path)
          end
        end
      end
    end
  end

  describe "GET /companies/new" do
    context "ログイン済みの場合" do
      context "company登録済みの場合" do
        context "adminユーザーの場合" do
          let(:user) { create(:user, :admin, :with_company) }

          it "トップページにリダイレクトすること" do
            sign_in user
            get new_company_path
            expect(response).to redirect_to(root_path)
          end
        end

        context "generalユーザーの場合" do
          let(:user) { create(:user, :general, :with_company) }

          it "トップページにリダイレクトすること" do
            sign_in user
            get new_company_path
            expect(response).to redirect_to(root_path)
          end
        end
      end

      context "company未登録の場合" do
        context "adminユーザーの場合" do
          let(:user) { create(:user, :admin, company: nil) }

          it "HTTPステータス200を返すこと" do
            sign_in user
            get new_company_path
            expect(response).to have_http_status(:ok)
          end
        end

        context "generalユーザーの場合" do
          let(:user) { create(:user, :general, company: nil) }

          it "招待待ちページにリダイレクトすること" do
            sign_in user
            get new_company_path
            expect(response).to redirect_to(invitation_required_path)
          end
        end
      end
    end
  end
end
