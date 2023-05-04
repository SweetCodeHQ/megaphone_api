class CreateTopicKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :topic_keywords do |t|
      t.references :topic, null: false, foreign_key: true
      t.references :keyword, null: false, foreign_key: true

      t.timestamps
    end
  end
end
