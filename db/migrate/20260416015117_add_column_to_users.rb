class AddColumnToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :name, :string
    add_column :users, :name_kana, :string
    add_column :users, :phone, :string
    add_column :users, :role, :integer, default: 0, null: false
  end
end
