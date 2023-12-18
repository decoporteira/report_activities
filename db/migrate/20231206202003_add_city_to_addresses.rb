class AddCityToAddresses < ActiveRecord::Migration[7.0]
  def change
    add_column :addresses, :city, :string
  end
end
