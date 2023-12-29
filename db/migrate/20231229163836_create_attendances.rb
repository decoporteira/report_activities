class CreateAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :attendances do |t|
      t.references :student, null: false, foreign_key: true
      t.boolean :presence, default: true 
      t.date :attendance_date

      t.timestamps
    end
  end
end
