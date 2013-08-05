class AddCustomToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :custom, :boolean
  end
end
