class CreateBanners < ActiveRecord::Migration[7.0]
  def change
    create_table :banners do |t|
      t.string :text
      t.string :link
      t.integer :purpose

      t.timestamps
    end
  end
end
