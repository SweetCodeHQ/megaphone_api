class AddAttributesToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :login_count, :integer, default: 0
    add_column :users, :clicked_generate_count, :integer, default: 0
  end
end
