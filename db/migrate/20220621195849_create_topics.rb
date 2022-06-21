class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics do |t|
      t.string :text, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
