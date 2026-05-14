class AddInvitedByOnlyToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :invited_by_only, :boolean, default: false, null: false
  end
end
