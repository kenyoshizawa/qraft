class NameFormatValidator < ActiveModel::EachValidator
  include NameFormatPatterns

  def validate_each(record, attribute, value)
    return if value.blank?

    unless value.match?(VALID_NAME_REGEX)
      record.errors.add(attribute, "は氏名の間に半角スペースを入れてください")
    end
  end
end
