# app/validators/allowed_domain_validator.rb
class AllowedDomainValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # 環境変数からドメインを取得
    allowed_domains = ENV["ALLOWED_DOMAIN"].to_s.split(",")

    # 入力されたメールアドレス（value）のドメイン部分を抽出
    domain = value.split("@").last

    # 許可されたドメインに含まれていない場合はエラーを追加
    unless allowed_domains.include?(domain)
      record.errors.add(attribute, "は社員用のアドレスを使用してください")
    end
  end
end
