class RemoveStudentIdFromAddresses < ActiveRecord::Migration[7.0]
  def change
    remove_column :addresses, :student_id, :integer
  end
end
