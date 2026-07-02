class CreateClients < ActiveRecord::Migration[7.2]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :name_kana, null: false
      t.string :postal_code, null: false
      t.string :address, null: false
      t.string :phone, null: false
      t.string :fax, null: false
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
