class AddContentTypeToTopics < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :content_type, :integer, default: 0
  end
end
