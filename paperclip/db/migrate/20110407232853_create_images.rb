class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string :id
      t.string :project
      t.string :build
      t.string :page
      t.string :browser
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.string :image_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
