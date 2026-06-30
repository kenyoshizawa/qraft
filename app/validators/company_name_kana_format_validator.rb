class CompanyNameKanaFormatValidator < ActiveModel::EachValidator
  VALID_COMPANY_NAME_KANA_REGEX = /\A[ァ-ヶー]+\z/

  def validate_each(record, attribute, value)
    return if value.blank?

    unless value.match?(VALID_COMPANY_NAME_KANA_REGEX)
      record.errors.add(attribute, :invalid, message: "は全角カタカナで入力してください")
    end
  end
end
