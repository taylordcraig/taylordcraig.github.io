class RemoveAdminColumnFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :admin
  end
end
