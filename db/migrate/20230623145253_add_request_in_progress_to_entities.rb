class AddRequestInProgressToEntities < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :request_in_progress, :boolean, default: false
  end
end
