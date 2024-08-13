class ChangeClassroomIdNullOnStudents < ActiveRecord::Migration[7.0]
  def change
    change_column_null :students, :classroom_id, true
  end
end
