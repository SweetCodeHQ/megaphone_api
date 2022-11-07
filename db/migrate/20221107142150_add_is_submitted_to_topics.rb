class AddIsSubmittedToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :submitted, :boolean, default: false
  end
end
