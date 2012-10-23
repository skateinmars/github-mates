class AddLatAndLngToCommiters < ActiveRecord::Migration
  def change
    add_column :commiters, :lat, :float
    add_column :commiters, :lng, :float
  end
end
