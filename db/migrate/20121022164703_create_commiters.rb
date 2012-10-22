class CreateCommiters < ActiveRecord::Migration
  def change
    create_table :commiters do |t|
      t.string :login, :null => false
      t.string :name
      t.string :location
      t.string :email
      t.string :company
      t.string :blog
      t.string :avatar_url

      t.timestamps
    end
  end
end
