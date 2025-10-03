class AddStatusToFollows < ActiveRecord::Migration[8.0]
  def change
    add_column :follows, :status, :integer, default: 0, null: false
  end
end
