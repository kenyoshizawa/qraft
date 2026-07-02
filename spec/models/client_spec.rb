require "rails_helper"

RSpec.describe Client, type: :model do
  describe "バリデーションに関するテスト" do
    it "適切なname、name_kana、postal_code、address、phone、faxが存在する場合、モデルの状態は有効であること" do
      client = build(:client)
      expect(client).to be_valid
    end

    describe "name_kana" do
      it "空白の場合、モデルの状態は無効であること" do
        client = build(:client, name_kana: nil)
        client.valid?
        expect(client.errors[:name_kana].count).to eq(1)
        expect(client.errors[:name_kana]).to include("を入力してください")
      end

      it "ひらがなが含まれている場合、モデルの状態は無効であること（CompanyNameKanaFormatValidator）" do
        client = build(:client, name_kana: "いとうこうむてん")
        client.valid?
        expect(client.errors[:name_kana].count).to eq(1)
        expect(client.errors[:name_kana]).to include("は全角カタカナで入力してください")
      end

      it "漢字が含まれている場合、モデルの状態は無効であること（CompanyNameKanaFormatValidator）" do
        client = build(:client, name_kana: "伊藤工務店")
        client.valid?
        expect(client.errors[:name_kana].count).to eq(1)
        expect(client.errors[:name_kana]).to include("は全角カタカナで入力してください")
      end

      it "半角カタカナが含まれている場合、モデルの状態は無効であること（CompanyNameKanaFormatValidator）" do
        client = build(:client, name_kana: "ｲﾄｳｺｳﾑﾃﾝ")
        client.valid?
        expect(client.errors[:name_kana].count).to eq(1)
        expect(client.errors[:name_kana]).to include("は全角カタカナで入力してください")
      end

      it "スペースが含まれている場合、モデルの状態は無効であること（CompanyNameKanaFormatValidator）" do
        client = build(:client, name_kana: "イトウ コウムテン")
        client.valid?
        expect(client.errors[:name_kana].count).to eq(1)
        expect(client.errors[:name_kana]).to include("は全角カタカナで入力してください")
      end

      it "英数字が含まれている場合、モデルの状態は無効であること（CompanyNameKanaFormatValidator）" do
        client = build(:client, name_kana: "イトウ123")
        client.valid?
        expect(client.errors[:name_kana].count).to eq(1)
        expect(client.errors[:name_kana]).to include("は全角カタカナで入力してください")
      end
    end
  end
end
