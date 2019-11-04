class AddUserIdToUserInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :user_infos, :user_id, :integer
  end
end
