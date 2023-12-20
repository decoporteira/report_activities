class AddPolyToAddress < ActiveRecord::Migration[7.0]
  def change
    add_reference :addresses, :addressable, polymorphic: true, index: true
  end
end
