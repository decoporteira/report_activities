class RemoveMissingFromActivity < ActiveRecord::Migration[7.0]
  def change
    remove_column :activities, :missing, :integer
  end
end
