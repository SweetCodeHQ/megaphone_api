class CreateAbstracts < ActiveRecord::Migration[7.0]
  def change
    create_table :abstracts do |t|
      t.references :topic, null: false, foreign_key: true
      t.string :text, null: false

      t.timestamps
    end
  end
end
