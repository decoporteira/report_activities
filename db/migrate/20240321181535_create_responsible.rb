class CreateResponsible < ActiveRecord::Migration[7.0]
  def change
    create_table :responsibles do |t|
      t.references :student, null: false, foreign_key: true
      t.references :financial_responsible, null: false, foreign_key: true

      t.timestamps
    end
  end
end
