class PhoneFormatValidator < ActiveModel::EachValidator
  HYPHEN_PATTERN = /[-－‐]/

  def validate_each(record, attribute, value)
    return if value.blank?

    if value.match?(HYPHEN_PATTERN)
      record.errors.add(attribute, "はハイフンなしで入力してください")
    end
  end
end
