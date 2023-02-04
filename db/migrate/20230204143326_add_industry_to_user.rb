class AddIndustryToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :industry, :integer, default: 0
  end
end
