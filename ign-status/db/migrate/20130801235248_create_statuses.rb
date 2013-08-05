class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :system
      t.string :status
      t.string :message
      t.boolean :custom
      t.timestamps
    end
  end
end