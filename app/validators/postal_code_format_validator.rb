class PostalCodeFormatValidator < ActiveModel::EachValidator
  HYPHEN_PATTERN = Regexp.union(
    "-",      # U+002D  半角ハイフン（キーボード入力）
    "\u2010", # ‐ ハイフン
    "\u2011", # ‑ ノンブレーキングハイフン
    "\u2012", # ‒ フィギュアダッシュ
    "\u2013", # – エンダッシュ
    "\u2014", # — エムダッシュ
    "\u2015", # ― 水平バー
    "\u2E3A", # ⸺ ツーエムダッシュ
    "\u2E3B", # ⸻ スリーエムダッシュ
    "\uFE31", # ︱ 縦書きエムダッシュ
    "\uFE32", # ︲ 縦書きエンダッシュ
    "\uFE58", # ﹘ 小エムダッシュ
    "\uFF0D", # － 全角ハイフンマイナス
    "\u30FC", # ー 片仮名長音符
    "\uFF70", # ｰ 半角カタカナ長音符
    "\u301C", # 〜 波ダッシュ（特に日本語で多発）
    "\u3030", # 〰 波線ダッシュ
    "\u30A0", # ゠ カタカナ・ひらがな二重ハイフン
    "\u2212"  # − マイナス記号（数学）
  )
  NON_NUMERIC_PATTERN = /[^0-9]/
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
