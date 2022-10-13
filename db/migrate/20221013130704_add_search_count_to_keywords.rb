class AddSearchCountToKeywords < ActiveRecord::Migration[7.0]
  def change
    add_column :keywords, :search_count, :integer, default: 1
  end
end
