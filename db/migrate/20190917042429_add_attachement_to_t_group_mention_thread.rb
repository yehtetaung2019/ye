class AddAttachementToTGroupMentionThread < ActiveRecord::Migration[5.2]
  def change
    add_column :t_group_mention_threads, :attachement, :string
  end
end
