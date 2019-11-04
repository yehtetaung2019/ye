class AddAttachementToTGroupThread < ActiveRecord::Migration[5.2]
  def change
    add_column :t_group_threads, :attachement, :string
  end
end
