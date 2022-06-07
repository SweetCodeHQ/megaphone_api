class CreateUserEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :user_entities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :entity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
