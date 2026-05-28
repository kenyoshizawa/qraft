require "rails_helper"

RSpec.describe Company, type: :model do
  describe "バリデーションに関するテスト" do
    it "適切なname、postal_code、address、phone、faxが存在する場合、モデルの状態は有効であること" do
      company = build(:company)
      expect(company).to be_valid
    end

    describe "postal_code" do
      it "空白の場合、モデルの状態は無効であること" do
        company = build(:company, postal_code: "")
        company.valid?
        expect(company.errors[:postal_code].count).to eq(1)
        expect(company.errors[:postal_code]).to include("を入力してください")
      end

      it "ハイフンが存在する場合、モデルの状態は無効であること" do
        company = build(:company, postal_code: "123-4567")
        company.valid?
        expect(company.errors[:postal_code].count).to eq(1)
        expect(company.errors[:postal_code]).to include("はハイフンなしで入力してください")
      end

      it "6桁の場合、モデルの状態は無効であること" do
        company = build(:company, postal_code: "123456")
        company.valid?
        expect(company.errors[:postal_code].count).to eq(1)
        expect(company.errors[:postal_code]).to include("は7桁で入力してください")
      end

      it "8桁の場合、モデルの状態は無効であること" do
        company = build(:company, postal_code: "12345678")
        company.valid?
        expect(company.errors[:postal_code].count).to eq(1)
        expect(company.errors[:postal_code]).to include("は7桁で入力してください")
      end

      it "全角数字が含まれている場合、モデルの状態は無効であること" do
        company = build(:company, postal_code: "１２３４５６７")
        company.valid?
        expect(company.errors[:postal_code].count).to eq(1)
        expect(company.errors[:postal_code]).to include("は半角数字で入力してください")
      end

      it "アルファベットが含まれている場合、モデルの状態は無効であること" do
        company = build(:company, postal_code: "abcdefg")
        company.valid?
        expect(company.errors[:postal_code].count).to eq(1)
        expect(company.errors[:postal_code]).to include("は半角数字で入力してください")
      end
    end

    describe "phone" do
      it "空白の場合、モデルの状態は無効であること" do
        company = build(:company, phone: "")
        company.valid?
        expect(company.errors[:phone].count).to eq(1)
        expect(company.errors[:phone]).to include("を入力してください")
      end

      it "半角ハイフン（U+002D）が含まれている場合、モデルの状態は無効であること (PhoneFormatValidator)" do
        company = build(:company, phone: "03-1234-5678")
        company.valid?
        expect(company.errors[:phone].count).to eq(1)
        expect(company.errors[:phone]).to include("はハイフンなしで入力してください")
      end

      it "全角ハイフン（U+FF0D）が含まれている場合、モデルの状態は無効であること (PhoneFormatValidator)" do
        company = build(:company, phone: "03－1234－5678")
        company.valid?
        expect(company.errors[:phone].count).to eq(1)
        expect(company.errors[:phone]).to include("はハイフンなしで入力してください")
      end

      it "ハイフン（U+2010）が含まれている場合、モデルの状態は無効であること (PhoneFormatValidator)" do
        company = build(:company, phone: "03‐1234‐5678")
        company.valid?
        expect(company.errors[:phone].count).to eq(1)
        expect(company.errors[:phone]).to include("はハイフンなしで入力してください")
      end

      it "アルファベットが含まれている場合、モデルの状態は無効であること (PhoneFormatValidator)" do
        company = build(:company, phone: "03123456a")
        company.valid?
        expect(company.errors[:phone].count).to eq(1)
        expect(company.errors[:phone]).to include("は半角数字で入力してください")
      end

      it "全角数字が含まれている場合、モデルの状態は無効であること (PhoneFormatValidator)" do
        company = build(:company, phone: "０３１２３４５６７８")
        company.valid?
        expect(company.errors[:phone].count).to eq(1)
        expect(company.errors[:phone]).to include("は半角数字で入力してください")
      end

      it "記号が含まれている場合、モデルの状態は無効であること (PhoneFormatValidator)" do
        company = build(:company, phone: "0312345678!")
        company.valid?
        expect(company.errors[:phone].count).to eq(1)
        expect(company.errors[:phone]).to include("は半角数字で入力してください")
      end

      it "存在しない番号の場合、モデルの状態は無効であること (PhoneFormatValidator)" do
        company = build(:company, phone: "0000000000")
        company.valid?
        expect(company.errors[:phone].count).to eq(1)
        expect(company.errors[:phone]).to include("は不正な値です")
      end
    end
  end
end
