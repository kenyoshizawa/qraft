class CreateCompanies < ActiveRecord::Migration[7.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :name_kana
      t.string :postal_code
      t.string :address
      t.string :phone
      t.string :fax

      t.timestamps
    end
  end
end
