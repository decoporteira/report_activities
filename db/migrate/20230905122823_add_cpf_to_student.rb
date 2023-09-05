class AddCpfToStudent < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :cpf, :string
  end
end
