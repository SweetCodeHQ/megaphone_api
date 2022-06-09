class UpdateMarkets < ActiveRecord::Migration[7.0]
  def change
    change_column_null :markets, :name, false
  end
end
