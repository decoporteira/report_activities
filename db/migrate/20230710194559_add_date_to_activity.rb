class AddDateToActivity < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :date, :date
  end
end
