class NameFormatValidator < ActiveModel::EachValidator
  VALID_NAME_REGEX = /\A[^\p{blank}]+ [^\p{blank}]+\z/

  def validate_each(record, attribute, value)
    return if value.blank?

    unless value.match?(VALID_NAME_REGEX)
      record.errors.add(attribute, "は氏名の間に半角スペースを入れてください")
    end
  end
end
