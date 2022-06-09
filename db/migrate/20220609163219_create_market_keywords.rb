class CreateMarketKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :market_keywords do |t|
      t.references :market, null: false, foreign_key: true
      t.references :keyword, null: false, foreign_key: true

      t.timestamps
    end
  end
end
