class AddProfileImageToUserInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :user_infos, :profile_image, :string
  end
end
