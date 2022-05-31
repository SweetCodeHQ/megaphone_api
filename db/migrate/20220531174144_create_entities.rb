class CreateEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :entities do |t|
      t.string :url, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
