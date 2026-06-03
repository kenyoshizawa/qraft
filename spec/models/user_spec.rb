require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーションに関するテスト" do
    it "新規作成(Create)時、適切なemail、password、roleが存在する場合、モデルの状態は有効であること" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "更新(Update)時、適切なname、name_kana、phoneを追加した場合、モデルの状態は有効であること" do
      user = create(:user)
      user.name = "山田 太郎"
      user.name_kana = "ヤマダ タロウ"
      user.phone = "09012345678"
      expect(user).to be_valid
    end

    describe "email" do
      it "許可されていないドメインの場合、モデルの状態は無効であること" do
        user = build(:user, email: "test@gmail.com")
        user.valid?
        expect(user.errors[:email]).to include("は社員用のアドレスを使用してください")
      end
    end

    describe "name" do
      it "半角スペースがない場合、モデルの状態は無効であること" do
        user = build(:user, name: "山田太郎")
        user.valid?
        expect(user.errors[:name]).to include("は氏名の間に半角スペースを入れてください")
      end

      it "全角スペースで区切られた場合、モデルの状態は無効であること" do
        user = build(:user, name: "山田　太郎")
        user.valid?
        expect(user.errors[:name]).to include("は氏名の間に半角スペースを入れてください")
      end
    end

    describe "name_kana" do
      it "全角カタカナ以外（ひらがな）の場合、モデルの状態は無効であること" do
        user = build(:user, name_kana: "やまだ たろう")
        user.valid?
        expect(user.errors[:name_kana]).to include("は全角カタカナで入力してください")
      end

      it "全角カタカナ以外（漢字）の場合、モデルの状態は無効であること" do
        user = build(:user, name_kana: "山田 太郎")
        user.valid?
        expect(user.errors[:name_kana]).to include("は全角カタカナで入力してください")
      end

      it "全角カタカナ以外（英字）の場合、モデルの状態は無効であること" do
        user = build(:user, name_kana: "Yamada Taro")
        user.valid?
        expect(user.errors[:name_kana]).to include("は全角カタカナで入力してください")
      end
    end
  end
end
