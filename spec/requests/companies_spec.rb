require "rails_helper"

RSpec.describe "Companies", type: :request do
  describe "GET /companies/:id" do
    context "adminユーザー（company登録済み）の場合" do
      let(:user) { create(:user, :admin, :with_company) }

      it "トップページにリダイレクトすること" do
        sign_in user
        get company_path(user.company)
        expect(response).to redirect_to(root_path)
      end
    end

    context "generalユーザー（company登録済み）の場合" do
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


    context "adminユーザー（company未登録）の場合" do
      let(:user) { create(:user, :admin, company: nil) }
      let(:other_user) { create(:user, :admin, :with_company) }

      it "自社情報登録ページにリダイレクトすること" do
        sign_in user
        get company_path(other_user.company)
        expect(response).to redirect_to(new_company_path)
      end
    end

    context "generalユーザー（company未登録）の場合" do
      let(:user) { create(:user, :general, company: nil) }
      let(:other_user) { create(:user, :admin, :with_company) }

      it "招待待ちページにリダイレクトすること" do
        sign_in user
        get company_path(other_user.company)
        expect(response).to redirect_to(invitation_required_path)
      end
    end
  end

  describe "GET /companies/new" do
    context "adminユーザー（company登録済み）の場合" do
      let(:user) { create(:user, :admin, :with_company) }

      it "トップページにリダイレクトすること" do
        sign_in user
        get new_company_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "generalユーザー（company登録済み）の場合" do
      let(:user) { create(:user, :general, :with_company) }

      it "トップページにリダイレクトすること" do
        sign_in user
        get new_company_path
        expect(response).to redirect_to(root_path)
      end
    end

    context "adminユーザー（company未登録）の場合" do
      let(:user) { create(:user, :admin, company: nil) }

      it "HTTPステータス200を返すこと" do
        sign_in user
        get new_company_path
        expect(response).to have_http_status(:ok)
      end
    end

    context "generalユーザー（company未登録）の場合" do
      let(:user) { create(:user, :general, company: nil) }

      it "招待待ちページにリダイレクトすること" do
        sign_in user
        get new_company_path
        expect(response).to redirect_to(invitation_required_path)
      end
    end
  end

  describe "POST /companies" do
    context "adminユーザー（company登録済み）の場合" do
      let(:user) { create(:user, :admin, :with_company) }

      it "トップページにリダイレクトすること" do
        sign_in user
        post companies_path, params: { company: attributes_for(:company) }
        expect(response).to redirect_to(root_path)
      end
    end

    context "generalユーザー（company登録済み）の場合" do
      let(:user) { create(:user, :general, :with_company) }

      it "トップページにリダイレクトすること" do
        sign_in user
        post companies_path, params: { company: attributes_for(:company) }
        expect(response).to redirect_to(root_path)
      end
    end

    context "adminユーザー（company未登録）の場合" do
      let(:user) { create(:user, :admin, company: nil) }

      context "有効なパラメータを送信した場合" do
        it "ステータスコード303を返すこと" do
          sign_in user
          post companies_path, params: { company: attributes_for(:company) }
          expect(response).to have_http_status(:see_other)
        end

        it "作成した自社情報がユーザーに紐づくこと" do
          sign_in user
          expect {
            post companies_path, params: { company: attributes_for(:company) }
          }.to change { user.reload.company_id }.from(nil)
        end

        it "自社情報の作成・保存に成功すること" do
          sign_in user
          expect {
            post companies_path, params: { company: attributes_for(:company) }
          }.to change(Company, :count).by(1)
        end

        it "自社情報編集ページにリダイレクトすること" do
          sign_in user
          post companies_path, params: { company: attributes_for(:company) }
          expect(response).to redirect_to(edit_company_path(user.reload.company))
        end
      end

      context "無効なパラメータを送信した場合" do
        it "ステータスコード422を返すこと" do
          sign_in user
          post companies_path, params: { company: attributes_for(:company, :invalid) }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "自社情報の作成・保存に失敗すること" do
          sign_in user
          expect {
            post companies_path, params: { company: attributes_for(:company, :invalid) }
          }.not_to change(Company, :count)
        end
      end
    end

    context "generalユーザー（company未登録）の場合" do
      let(:user) { create(:user, :general, company: nil) }

      it "招待待ちページにリダイレクトすること" do
        sign_in user
        post companies_path, params: { company: attributes_for(:company) }
        expect(response).to redirect_to(invitation_required_path)
      end
    end
  end

  describe "GET /companies/:id/edit" do
    context "adminユーザー（company登録済み）の場合" do
      let(:user) { create(:user, :admin, :with_company) }

      it "HTTPステータス200を返すこと" do
        sign_in user
        get edit_company_path(user.company)
        expect(response).to have_http_status(:ok)
      end
    end

    context "generalユーザー（company登録済み）の場合" do
      let(:user) { create(:user, :general, :with_company) }

      it "トップページにリダイレクトすること" do
        sign_in user
        get edit_company_path(user.company)
        expect(response).to redirect_to(root_path)
      end
    end

    context "adminユーザー（company未登録）の場合" do
      let(:user) { create(:user, :admin, company: nil) }
      let(:other_user) { create(:user, :admin, :with_company) }

      it "自社情報登録ページにリダイレクトすること" do
        sign_in user
        get edit_company_path(other_user.company)
        expect(response).to redirect_to(new_company_path)
      end
    end

    context "generalユーザー（company未登録）の場合" do
      let(:user) { create(:user, :general, company: nil) }
      let(:other_user) { create(:user, :admin, :with_company) }

      it "招待待ちページにリダイレクトすること" do
        sign_in user
        get edit_company_path(other_user.company)
        expect(response).to redirect_to(invitation_required_path)
      end
    end
  end

  describe "PATCH /companies/:id" do
    context "adminユーザー（company登録済み）の場合" do
      let(:user) { create(:user, :admin, :with_company) }

      context "有効なパラメータを送信した場合" do
        it "ステータスコード303を返すこと" do
          sign_in user
          patch company_path(user.company), params: { company: attributes_for(:company) }
          expect(response).to have_http_status(:see_other)
        end

        it "自社情報の更新に成功すること" do
          sign_in user
          expect {
            patch company_path(user.company), params: { company: attributes_for(:company, name: "新しい会社名") }
          }.to change { user.company.reload.name }.to("新しい会社名")
        end

        it "自社情報編集ページにリダイレクトすること" do
          sign_in user
          patch company_path(user.company), params: { company: attributes_for(:company) }
          expect(response).to redirect_to(edit_company_path(user.company))
        end
      end

      context "無効なパラメータを送信した場合" do
        it "ステータスコード422を返すこと" do
          sign_in user
          patch company_path(user.company), params: { company: attributes_for(:company, :invalid) }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "自社情報の更新に失敗すること" do
          sign_in user
          expect {
            patch company_path(user.company), params: { company: attributes_for(:company, :invalid) }
          }.not_to change { user.company.reload.name }
        end
      end
    end

    context "generalユーザー（company登録済み）の場合" do
      let(:user) { create(:user, :general, :with_company) }

      it "トップページにリダイレクトすること" do
        sign_in user
        patch company_path(user.company), params: { company: attributes_for(:company) }
        expect(response).to redirect_to(root_path)
      end
    end

    context "adminユーザー（company未登録）の場合" do
      let(:user) { create(:user, :admin, company: nil) }
      let(:other_user) { create(:user, :admin, :with_company) }

      it "自社情報登録ページにリダイレクトすること" do
        sign_in user
        patch company_path(other_user.company), params: { company: attributes_for(:company) }
        expect(response).to redirect_to(new_company_path)
      end
    end

    context "generalユーザー（company未登録）の場合" do
      let(:user) { create(:user, :general, company: nil) }
      let(:other_user) { create(:user, :admin, :with_company) }

      it "招待待ちページにリダイレクトすること" do
        sign_in user
        patch company_path(other_user.company), params: { company: attributes_for(:company) }
        expect(response).to redirect_to(invitation_required_path)
      end
    end
  end
end
