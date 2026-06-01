class NameKanaFormatValidator < ActiveModel::EachValidator
  include NameFormatPatterns

  def validate_each(record, attribute, value)
    return if value.blank?

    if !value.match?(VALID_NAME_REGEX)
      record.errors.add(attribute, :invalid, message: "は氏名の間に半角スペースを入れてください")
    elsif !value.match?(VALID_NAME_KANA_REGEX)
      record.errors.add(attribute, :invalid, message: "は全角カタカナで入力してください")
    end
  end
end
