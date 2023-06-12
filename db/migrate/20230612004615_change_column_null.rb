class ChangeColumnNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :entities, :name, true
  end
end
