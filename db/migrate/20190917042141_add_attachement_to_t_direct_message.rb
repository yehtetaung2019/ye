class AddAttachementToTDirectMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :t_direct_messages, :attachement, :string
  end
end
