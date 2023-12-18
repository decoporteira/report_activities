class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :street
      t.integer :number
      t.string :unit
      t.string :neighborhood
      t.string :state
      t.string :country
      t.string :zip_code
      t.references :student, null: false, foreign_key: true

      t.timestamps
    end
  end
end
