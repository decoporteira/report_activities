class AddCellPhoneToTeachers < ActiveRecord::Migration[7.0]
  def change
    add_column :teachers, :cel_phone, :string
    add_column :teachers, :phone, :string
  end
end
