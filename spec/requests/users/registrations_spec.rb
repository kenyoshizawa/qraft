require "rails_helper"

RSpec.describe "Users::Registrations", type: :request do
  describe "PATCH /users/deactivate" do
    context "ログイン済みユーザーの場合" do
      context "retiredユーザーの場合" do
        let(:user) { create(:user) }

        it "roleがretiredに更新されること" do
          sign_in user
          patch deactivate_user_registration_path
          expect(user.reload.role).to eq "retired"
        end

        it "ログアウトされること" do
          sign_in user
          patch deactivate_user_registration_path
          expect(controller.current_user).to be_nil
        end

        it "root_pathにリダイレクトされること" do
          sign_in user
          patch deactivate_user_registration_path
          expect(response).to redirect_to root_path
        end

        it "アカウント無効化に関するフラッシュメッセージが表示されること" do
          sign_in user
          patch deactivate_user_registration_path
          expect(flash[:notice]).to eq "アカウントを無効化しました。"
        end
      end
    end

    context "ログインしていないユーザーの場合" do
      context "retiredユーザーの場合" do
        let(:user) { create(:user, :retired) }

        it "ログインできないこと" do
          sign_in user
          expect(user.active_for_authentication?).to be false
        end

        it "メッセージキーretired_accountを返すこと" do
          expect(user.inactive_message).to eq :retired_account
        end
      end
    end
  end
end
