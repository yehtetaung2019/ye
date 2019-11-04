class AddAttachementToTDirectThread < ActiveRecord::Migration[5.2]
  def change
    add_column :t_direct_threads, :attachement, :string
  end
end
