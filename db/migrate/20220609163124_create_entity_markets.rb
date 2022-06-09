class CreateEntityMarkets < ActiveRecord::Migration[7.0]
  def change
    create_table :entity_markets do |t|
      t.references :entity, null: false, foreign_key: true
      t.references :market, null: false, foreign_key: true

      t.timestamps
    end
  end
end
