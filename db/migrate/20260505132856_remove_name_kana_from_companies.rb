class RemoveNameKanaFromCompanies < ActiveRecord::Migration[7.2]
  def change
    remove_column :companies, :name_kana, :string, null: false
  end
end
