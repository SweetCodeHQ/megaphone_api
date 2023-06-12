class AddCreditsToEntities < ActiveRecord::Migration[7.0]
  def change
    add_column :entities, :credits, :integer
  end
end
