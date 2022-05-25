class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.boolean :is_admin, default: false

      t.timestamps
    end
  end
end
