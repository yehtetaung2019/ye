class CreateUserInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :user_infos do |t|
      t.boolean :gender
      t.date :dob
      t.string :work

      t.timestamps
    end
  end
end
