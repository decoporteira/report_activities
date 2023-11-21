class CreateResumes < ActiveRecord::Migration[7.0]
  def change
    create_table :resumes do |t|
      t.text :written_report
      t.integer :status
      t.date :date
      t.references :student, null: false, foreign_key: true

      t.timestamps
    end
  end
end
