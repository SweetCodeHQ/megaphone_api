class AddDatesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :accepted_eula_on, :datetime
    add_column :users, :accepted_cookies_on, :datetime
    add_column :users, :accepted_privacy_on, :datetime
    add_column :users, :saw_banner_on, :datetime
  end
end
