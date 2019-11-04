class AddAttachementToTGroupMentionMsg < ActiveRecord::Migration[5.2]
  def change
    add_column :t_group_mention_msgs, :attachement, :string
  end
end
