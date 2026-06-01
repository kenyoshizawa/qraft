module NameFormatPatterns
  VALID_NAME_REGEX = /\A[^\p{blank}]+ [^\p{blank}]+\z/
  VALID_NAME_KANA_REGEX = /\A[ァ-ヶー]+(?: [ァ-ヶー]+)*\z/
end
