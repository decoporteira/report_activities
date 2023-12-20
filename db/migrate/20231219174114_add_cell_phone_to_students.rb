class AddCellPhoneToStudents < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :cel_phone, :string
  end
end
