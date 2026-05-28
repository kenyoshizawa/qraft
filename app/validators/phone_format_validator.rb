class PhoneFormatValidator < ActiveModel::EachValidator
  include NumericFormatPatterns

  def validate_each(record, attribute, value)
    return if value.blank?

    if value.match?(HYPHEN_PATTERN)
      record.errors.add(attribute, "はハイフンなしで入力してください")
    elsif value.match?(NON_NUMERIC_PATTERN)
      record.errors.add(attribute, "は半角数字で入力してください")
    elsif !Phonelib.valid_for_country?(value, :jp)
      record.errors.add(attribute, :invalid)
    end
  end
end
