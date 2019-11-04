class AddAttachementToTGroupMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :t_group_messages, :attachement, :string
  end
end
