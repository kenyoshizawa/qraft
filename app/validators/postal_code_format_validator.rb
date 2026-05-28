class PostalCodeFormatValidator < ActiveModel::EachValidator
  include NumericFormatPatterns

  VALID_LENGTH = 7

  def validate_each(record, attribute, value)
    return if value.blank?

    if value.match?(HYPHEN_PATTERN)
      record.errors.add(attribute, "はハイフンなしで入力してください")
    elsif value.match?(NON_NUMERIC_PATTERN)
      record.errors.add(attribute, "は半角数字で入力してください")
    elsif value.length != VALID_LENGTH
      record.errors.add(attribute, "は7桁で入力してください")
    end
  end
end
