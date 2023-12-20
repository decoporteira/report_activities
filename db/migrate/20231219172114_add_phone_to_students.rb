class AddPhoneToStudents < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :phone, :string
  end
end
