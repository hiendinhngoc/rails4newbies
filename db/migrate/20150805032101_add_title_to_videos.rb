class AddTitleToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :title, :string
  end
end
