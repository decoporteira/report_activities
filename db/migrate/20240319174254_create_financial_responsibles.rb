class CreateFinancialResponsibles < ActiveRecord::Migration[7.0]
  def change
    create_table :financial_responsibles do |t|
      t.string :name
      t.string :phone
      t.string :cpf
      t.string :email

      t.timestamps
    end
  end
end
