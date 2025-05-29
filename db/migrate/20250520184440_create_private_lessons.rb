class CreatePrivateLessons < ActiveRecord::Migration[7.0]
  def change
    create_table :private_lessons do |t|
      t.references :current_plan, null: false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.text :notes

      t.timestamps
    end
  end
end
